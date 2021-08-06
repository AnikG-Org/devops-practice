# Docker-Ansible-Wordpress

This project deploys & runs a containerized WordPress (PHP7 FPM, Nginx, MySQL) using Ansible + Docker. This project has been tested on AWS as well - in fact, the default
user is 'root'. Feel free to modify the 'system_user' variable as required.

## Prerequisites

* A Linux machine from where to run this playbook with python and ansible installed.
```bash
$ python3 -m virtualenv venv
$ source venv/bin/activate
$ (venv) pip3 install ansible
```

* A Linux machine on which you want to deploy the Docker containers. This could be the same machine described in the previous step, or any another host running Linux (could also be on the cloud), as long as it is accessible by Ansible. 

If you are using SSH keys on this machine (recommended), make sure you modify your local (where ansible is running) ssh config. An example ssh config (~/.ssh/config) is as follows:
```bash
Host {ip}
  User root/ubuntu
  IdentityFile /home/{{}}.pem
  IdentitiesOnly yes
```

* The Linux user that can be used by Ansible to access the host. Default is 'ubuntu' (to support AWS), however feel free to use any other user. Make sure to update the 'system_user' variable inside group_vars/all/vars.ymll accordingly.

## How does it work?
As such I made this project as a single Ansible playbook, three roles (each containing their own tasks), templates for Docker and Nginx, and a set of default variables (group_vars/all/vars.yml):
```bash
├── ansible.cfg
├── group-vars/all/
│   └── vars.yml
├── hosts
├ 
├── README.md
├── roles
│   ├── docker
│   │   └── tasks
│   │       └── main.yml
│   ├── python
│   │   └── tasks
│   │       └── main.yml
│   └── wordpress-docker-with-var-prompt
│       ├── tasks
│       │   └── main.yml
│       └── templates
│           ├── docker-compose.j2
│           └── wordpress-nginx.j2
└── wordpress-docker-with-var-prompt.yml // wordpress-docker.yml   & playbook-connectivity.yaml
```

The workflow of this project is simple and is made up of two phases. 

In the first phase, it asks the user to input some data, which will be stored as environmental variables through the rest of the project. 

Finally, in the second phase, three roles will be executed:

**python**

This Ansible role will install Python on newly bootstrapped host. This is usually a new host which you never even SSH-ed to. In order for Ansible to work, Python must be installed (if missing).

**docker**

This Ansible role will perform all necessary tasks to setup and run Docker and Docker Compose:

* Install packages necessary for APT to use a repository over HTTPS.
* Add and setup official Docker APT repositories.
* Install packages needed for AUFS storage drivers.
* Add user to Docker group.

**wordpress-docker-with-var-prompt**

This is where the magic truly happens. This Ansible playbook will Deploy & run Docker Compose project for WordPress instance. Which consists of 3 separate containers running:
* WordPress (PHP7 FPM)
* Nginx
* MySQL (MariaDB)

The following directory structure will be deployed on the Ubuntu Docker host:

```bash
compose-wordpress/
├── docker-compose.yml
├── logs
├── nginx
├── wordpress
└── wp-db-data
```

Both the Nginx configuration and the docker-compose file are built from a Jinja template by Ansible. These inherit values from global vars and user vars, and are eventually copied to the respective containers through docker volumes.

## Installation Instructions (interactive mode)

**1. Get source code for docker-ansible-wordpress, i.e:**

```
https://github.com/AnikG-Org/devops-practice/blob/main/ansible/Ansible_project/docker-wordpress-with-ansible
```

**2. Update docker-ansible-wordpress/hosts inventory file with your AWS instance Public IP, i.e:**

```
[wordpress]
x.x.x.x
```

**3. Run wordpress-docker-with-var-prompt playbook, using hosts inventory file, i.e:**

```
ansible-playbook -i hosts wordpress-docker.yml
```

After which all you need to do is follow on screen instructions. Process which in <= 5 minutes, host you defined in "hosts" will be fully updated, configured and running containerized WordPress instance.

Please note that default values are defined in square brackets, which you can use by simply hitting enter, i.e:
```
Specify WordPress database name [wordpress]:
```

In this case your WordPress database name will be: "wordpress".

## Installation Instructions (non-interactive mode)

If you want to run this playbook in non interactive mode (which is enabled by default) using parametrers, you can do so by:

```
ansible-playbook wordpress-docker-with-var-prompt.yml -i hosts --extra-vars "domain=custom.domain2.com wp_version=4.7.5 wp_db_name=wpdb wp_db_tb_pre=wp_ wp_db_host=mysql wp_db_psw=change-P3"
```
