# Pull base image 
From tomcat:8-jre8

# Maintainer 
MAINTAINER "valaxytech@gmail.com" 
COPY webapp/target/weapp.war /opt/tomcat/webapps

