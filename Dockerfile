# Pull base image 
From tomcat:8-jre8

# Maintainer 
MAINTAINER "valaxytech@gmail.com" 
COPY ./webapp.war /opt/tomcat/apache-tomcat-9.0.69/webapps

