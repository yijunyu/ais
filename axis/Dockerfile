FROM alpine:latest
MAINTAINER Yijun Yu <y.yu@open.ac.uk>
RUN apk add --update --no-cache openjdk8
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
RUN wget http://archive.apache.org/dist/axis/axis2/java/core/1.6.2/axis2-1.6.2-bin.zip
RUN unzip axis2-1.6.2-bin.zip
ENV AXIS2_HOME /axis2-1.6.2
RUN apk update && apk add ca-certificates wget && update-ca-certificates && wget "https://yijunyu.github.io/archive/xacmllight-2.2.tar.gz"
RUN tar xvfz xacmllight-2.2.tar.gz
RUN cp /xacmllight-2.2/info_gryb_xacml_config.xml /axis2-1.6.2
RUN $JAVA_HOME/bin/jar xvf xacmllight-2.2/authz.aar META-INF/services.xml
RUN sed -i -e 's/useOriginalwsdl">true/useOriginalwsdl">false/g' META-INF/services.xml
RUN $JAVA_HOME/bin/jar uvf xacmllight-2.2/authz.aar META-INF/services.xml
RUN cp xacmllight-2.2/authz.aar axis2-1.6.2/repository/services
RUN cd /xacmllight-2.2/test; chmod +x *.sh
EXPOSE 8080
CMD /axis2-1.6.2/bin/axis2server.sh
