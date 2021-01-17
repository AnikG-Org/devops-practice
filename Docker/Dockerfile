FROM centos:latest

RUN yum install -y httpd zip unzip
ADD https://www.free-css.com/assets/files/free-css-templates/download/page263/den.zip /var/www/html/ 
WORKDIR /var/www/html/
RUN unzip den.zip
RUN cp -rvf den/* . && rm -rf /var/www/html/den.zip && rm -rf /var/www/html/den
EXPOSE 80
CMD ["/sbin/httpd", "-D" , "FOREGROUND"]
