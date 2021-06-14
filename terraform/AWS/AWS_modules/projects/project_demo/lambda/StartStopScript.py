import json
import boto3
import traceback
import re
import arrow
import datetime
import sys
from datetime import timedelta

region = 'ap-south-1'

EC2_RESOURCE = boto3.resource('ec2')

START_TAG_KEY = re.compile('StartTime-(?P<timezone>\w+/\w+|UTC)-SMTWTFS', re.IGNORECASE)
STOP_TAG_KEY = re.compile('StopTime-(?P<timezone>\w+/\w+|UTC)-SMTWTFS', re.IGNORECASE)

TAG_ENCODING = {
    'Sunday': 0,
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6
}


def get_date_object(time, local_now):
    hour, minute = time.split('h')
    date_obj = arrow.get(
        local_now.year,
        local_now.month,
        local_now.day,
        int(hour),
        int(minute),
        0,
        0,
        local_now.tzinfo
    )

    return date_obj


def get_all_scheduled_instances():
    instances = EC2_RESOURCE.instances.all()
    scheduled_instances = []

    for instance in instances:
        tags = get_start_stop_tags(instance)
        if not tags:
            continue
        scheduled_instances.append((instance, *tags))
    
    return scheduled_instances


def get_start_stop_tags(instance):
    if not instance.tags:
        print("InstanceId '{}' does not have Start/Stop Tags".format(instance.id))
        return None

    start_tag = next((t for t in instance.tags if START_TAG_KEY.match(t['Key'])), None)
    stop_tag = next((t for t in instance.tags if STOP_TAG_KEY.match(t['Key'])), None)

    if not start_tag and not stop_tag:
        print("InstanceId '{}' does not have Start/Stop Tags".format(instance.id))
        return None

    return start_tag, stop_tag


def get_desired_state(start_time, stop_time):
    time_zone = get_timezone(start_time, stop_time)

    utc_now = arrow.utcnow()
    local_now = utc_now.to(time_zone)
    print("Current '{}' Time: {}".format(time_zone, local_now))

    today = local_now.strftime("%A")
    validate_time_tag(start_time, stop_time)

    start_time = get_todays_schedule_time(start_time, today)
    stop_time = get_todays_schedule_time(stop_time, today)

    no_schedule = re.compile('^n/a$|$^')
    running_all_day = re.compile('running')
    stopped_all_day = re.compile('stopped')

    if running_all_day.match(start_time) or running_all_day.match(stop_time):
        return 'running'

    if stopped_all_day.match(start_time) or stopped_all_day.match(stop_time):
        return 'stopped'

    if no_schedule.match(start_time) and no_schedule.match(stop_time):
        # no start or stop schedule, do nothing
        return 'none'

    if no_schedule.match(start_time):
        stop_date = get_date_object(stop_time, local_now)
        if local_now >= stop_date:
            return 'stopped'
        else:
            return 'none'

    if no_schedule.match(stop_time):
        start_date = get_date_object(start_time, local_now)
        if local_now >= start_date:
            return 'running'
        else:
            return 'none'

    stop_date = get_date_object(stop_time, local_now)
    start_date = get_date_object(start_time, local_now)
    if start_date <= local_now <= stop_date:
        return 'running'
    else:
        return 'stopped'


def get_todays_schedule_time(time, today):
    time = time['Value'].split('|')[TAG_ENCODING[today]]  # type: str
    time = time.strip().lower()
    return time


def validate_time_tag(start_time, stop_time):
    if len(start_time['Value'].split('|')) != 7:
        raise ValueError('Start Tag Value in wrong format')
    if len(stop_time['Value'].split('|')) != 7:
        raise ValueError('Stop Tag Value in wrong format')


def get_timezone(start_time, stop_time):
    start_time_tz = START_TAG_KEY.match(start_time['Key']).group('timezone')
    stop_time_tz = STOP_TAG_KEY.match(stop_time['Key']).group('timezone')
    if start_time_tz != stop_time_tz:
        raise ValueError('Start Time Zone and Stop Time Zone are different')
    return start_time_tz


def lambda_handler(event, context):
    print("Finding instances with schedules...")
    instances = get_all_scheduled_instances()
    print("")
    print("Processing Schedules...")
    startmsg = ""
    for instance, start_tag, stop_tag in instances:
        current_state = instance.state['Name']
        try:
            desired_state = get_desired_state(start_tag, stop_tag)
        except (KeyError, IndexError, ValueError) as msg:
            print("Could not decode tags for InstanceId '{}".format(instance.id))
            print(traceback.format_exc())
        else:
            print("InstanceId '{}' current: {}".format(
                instance.id,
                current_state.capitalize()
            ))
            print("InstanceId '{}' desired: {}".format(
                instance.id,
                desired_state.capitalize()
            ))
            if current_state == 'stopped' and desired_state == 'running':
                print("Starting Instance '{}'".format(instance.id))
                output1 = instance.start()
                val1 = output1["StartingInstances"]
                startmsg = startmsg + str(val1) + "\n\n"
                print('Publish Messsage to SNS Topic')
                subject_str = 'Status change of EC2 instances'
                DT = datetime.datetime.now() + timedelta(hours = 5.5)
                current_time = DT.strftime("%Y-%m-%d %H:%M:%S")
                msg = "IST Time : " + current_time + "\n" + str(startmsg) + "\n"

            elif current_state == 'running' and desired_state == 'stopped':
                print("Stopping Instance '{}'".format(instance.id))
                try:
                    output2 = instance.stop()
                    val2 = output2["StoppingInstances"]
                    startmsg = startmsg + str(val2) + "\n\n"
                    print('Publish Messsage to SNS Topic')
                    subject_str = 'Status change of EC2 instances'
                    DT = datetime.datetime.now() + timedelta(hours = 5.5)
                    current_time = DT.strftime("%Y-%m-%d %H:%M:%S")
                    msg = "IST Time : " + current_time + "\n" + str(startmsg) + "\n"
                except Exception as error:
                    msg="For EC2 instance having instance id: "+instance.id+" the below error occured "+"\n\n"+str(error)
                    print(msg)
                    subject_str="Error in EC2"
                    snsClient = boto3.client('sns',region)
                    response = snsClient.publish(TopicArn='arn:aws:sns:ap-south-1:954631081192:KifsplManagedServiceAlert',Message=msg,Subject=subject_str)
                    continue
            else:
                print("Nothing to do for InstanceId '{}'".format(instance.id))
                subject_str = "No status change for EC2 instances"
                msg = None
        print("")
    snsClient = boto3.client('sns',region)
    if msg is None:
        print ("NO STATUS CHANGE FOR ANY INSTANCE")
    else:
        response = snsClient.publish(TopicArn='arn:aws:sns:ap-south-1:954631081192:KifsplManagedServiceAlert',Message=msg,Subject=subject_str)
    
if __name__ == "__main__":
    lambda_handler(None, None)
