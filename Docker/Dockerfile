FROM centos:latest

RUN yum install -y httpd zip unzip
WORKDIR /var/www/html/
ADD https://www.free-css.com/assets/files/free-css-templates/download/page263/den.zip ./ 
RUN unzip den.zip
RUN cp -rvf den/* . && rm -rf /var/www/html/den.zip
EXPOSE 80
CMD ["/sbin/httpd", "-D" , "FOREGROUND"]
