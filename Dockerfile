# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# This container is made to execute RobotFramework test.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

FROM python:2.7-slim

MAINTAINER Wu Jiansong <360517703@163.com>

ENV REMOTE_URL=http://localhost:4444/wd/hub

# Install Ubuntu packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    alien \
    dpkg-dev \
    debhelper \
    build-essential \
    libaio1 \
    wget \
 && rm -rf /var/lib/apt/lists/* 


# Install oracle
# Reference: https://help.ubuntu.com/community/Oracle%20Instant%20Client
# Download RPM files from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
# Get Oracle Client (this isn't the offical download location, but at least it works without logging in!)
RUN wget --no-check-certificate https://raw.githubusercontent.com/bumpx/oracle-instantclient/master/oracle-instantclient12.2-basiclite-12.2.0.1.0-1.x86_64.rpm \

# Alien RPM package installer
 && alien -i *.rpm \

# Cleaning up the packages downloaded
 && rm *.rpm \
 && apt-get purge -y --auto-remove wget alien

RUN echo "/usr/lib/oracle/12.2/client64/lib/" >> /etc/ld.so.conf.d/oracle.conf \
&& echo '#!/bin/bash\n\
export ORACLE_HOME=/usr/lib/oracle/12.2/client64\n\
export PATH=$PATH:$ORACLE_HOME/bin' >> /etc/profile.d/oracle.sh \
&& chmod +x /etc/profile.d/oracle.sh \
&& /etc/profile.d/oracle.sh \
&& ldconfig

RUN pip install -U pip \
    requests \
    selenium \
    xlrd \
    cx-Oracle \
    pyhive \
    pymysql \
    robotframework \
    dbbot \
    robotframework-selenium2library \
    robotframework-databaselibrary \
    robotframework-requests \
    robotframework-sshlibrary \
    robotframework-excelLibrary && \
    sed -i "s#formatting_info=True,##g" /usr/local/lib/python2.7/site-packages/ExcelLibrary/ExcelLibrary.py && \
    sed -i "s#remote_url=False#remote_url='$REMOTE_URL'#g" /usr/local/lib/python2.7/site-packages/SeleniumLibrary/keywords/browsermanagement.py && \
    echo Asia/Shanghai > /etc/timezone && \
    mv /etc/localtime /etc/localtime.bak && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
