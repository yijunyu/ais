FROM ubuntu
MAINTAINER Yijun Yu <y.yu@open.ac.uk>
RUN apt-get update

RUN apt-get install -y ssh

RUN apt-get install -y apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
RUN chown -R www-data:www-data /var/www
RUN chmod -R 775 /var/www

RUN apt-get install -y openjdk-6-jdk
ENV JAVA_HOME /usr/lib/jvm/java-6-openjdk-amd64

RUN wget http://apache.mirrors.timporter.net//axis/axis2/java/core/1.6.2/axis2-1.6.2-bin.zip
RUN apt-get install unzip
RUN unzip axis2-1.6.2-bin.zip
ENV AXIS2_HOME /axis2-1.6.2

RUN apt-get install -y curl

RUN wget "http://downloads.sourceforge.net/project/xacmllight/xacmllight/xacmllight-2.2/xacmllight-2.2.tar.gz?r=&ts=1394716890&use_mirror=kent"
RUN tar xvfz "xacmllight-2.2.tar.gz?r=&ts=1394716890&use_mirror=kent"
RUN cp /xacmllight-2.2/info_gryb_xacml_config.xml /axis2-1.6.2
RUN jar xvf xacmllight-2.2/authz.aar META-INF/services.xml
RUN sed -i -e 's/useOriginalwsdl">true/useOriginalwsdl">false/g' META-INF/services.xml
RUN jar uvf xacmllight-2.2/authz.aar META-INF/services.xml
RUN cp xacmllight-2.2/authz.aar axis2-1.6.2/repository/services
RUN cd /xacmllight-2.2/test; chmod +x *.sh

RUN apt-get install -y python-setuptools
RUN easy_install supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /usr/local/etc/supervisord.conf
EXPOSE 22 80 8080
CMD ["/usr/local/bin/supervisord", "-c", "/usr/local/etc/supervisord.conf"]

