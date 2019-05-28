FROM  r.cfcr.io/redpillanalytics/jdk:8u211 AS BUILD

ENV JAVA_HOME=/usr/java/jdk1.8.0_211-amd64 \
    VERSION=12.2.1.3.0 \
    ORACLE_HOME=/u01/oracle/odi1 \
    ODI_AGENT_PORT=20910 \
    DOMAIN_NAME="${DOMAIN_NAME:-base_domain}" \
    DOMAIN_ROOT="${DOMAIN_ROOT:-/u01/oracle/user_projects/domains}"

ENV PATH=$PATH:$ORACLE_HOME/oracle_common/common/bin:$ORACLE_HOME/container-scripts:$ORACLE_HOME/OPatch \
    ODI_JAR=fmw_${VERSION}_odi.jar \
    ODI_JAR2=fmw_${VERSION}_odi2.jar

RUN yum -y install unzip make gcc && \
    yum clean all && \
    mkdir su-exec-tmp && \
    wget --quiet -O su-exec-tmp/su-exec.zip https://t.co/hsr02to11V && \
    unzip su-exec-tmp/su-exec.zip -d su-exec-tmp && \
    cd su-exec-tmp/su-exec-0.2 && \
    make && \
    mv su-exec /usr/bin/ && \
    chmod u+s /usr/bin/su-exec && \
    cd / && \
    wget -q -O $ODI_JAR https://s3.amazonaws.com/rpa-oracle-software/odi/${VERSION}/${ODI_JAR} && \
    wget -q -O $ODI_JAR2 https://s3.amazonaws.com/rpa-oracle-software/odi/${VERSION}/${ODI_JAR2} && \
    mkdir /u01 && \
    useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle && \
    mkdir -p /u01/oracle/container-scripts /u01/oracle/logs && \
    chmod a+xr /u01

COPY oraInst.loc /u01/
COPY container-scripts/* /u01/oracle/container-scripts/

RUN chown oracle:oracle -R /u01 && \
    chmod a+xr /u01/oracle/container-scripts/*.* && \
    su-exec oracle $JAVA_HOME/bin/java -jar $ODI_JAR -silent -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="Standalone Installation" && \
    rm ${ODI_JAR} ${ODI_JAR2}
