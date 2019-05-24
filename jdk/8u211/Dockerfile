FROM oraclelinux:7-slim AS BUILD

ENV JAVA_HOME=/usr/java/jdk1.8.0_211-amd64

RUN yum -y install wget which && \
    wget -q -O jdk-8u211-linux-x64.rpm https://s3.amazonaws.com/rpa-checkmate-resources/java/jdk-8u211-linux-x64.rpm && \
    yum -y localinstall jdk-8u211-linux-x64.rpm && \
    java -version && \
    rm jdk-8u211-linux-x64.rpm && \
    yum clean all
