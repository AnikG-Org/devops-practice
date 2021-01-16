FROM centos:latest

RUN yum install -y httpd zip unzip wget
WORKDIR /var/www/html/
RUN wget https://templated.co/industrious/download --no-check-certificate && mv ./download templated-industrious.zip
RUN mkdir /var/www/html/templated-industrious &&  mv templated-industrious.zip ./templated-industrious/ && unzip ./templated-industrious/templated-industrious.zip
RUN cp -rvf templated-industrious/* . && rm -rf /var/www/html/templated-industrious.zip
EXPOSE 80
CMD ["/sbin/httpd", "-D" , "FOREGROUND"]
