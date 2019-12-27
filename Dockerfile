FROM  mysql/mysql-server

ENV JDK=jdk-8u231-linux-x64
ENV JDK_RPM=${JDK}.rpm
ENV JAVA_HOME=/usr/java/jdk1.8.0_231-amd64
ENV VERSION=12.2.1.3.0
ENV ORACLE_BASE=/opt/oracle
ENV ORACLE_HOME=${ORACLE_BASE}/odi1
ENV ODI_AGENT_PORT=20910
ENV DOMAIN_NAME="${DOMAIN_NAME:-base_domain}"
ENV DOMAIN_ROOT="${DOMAIN_ROOT:-/u01/oracle/user_projects/domains}"

ENV PATH=$PATH:$ORACLE_HOME/oracle_common/common/bin:$ORACLE_BASE/container-scripts:$ORACLE_HOME/OPatch
ENV ODI_JAR=fmw_${VERSION}_odi.jar
ENV ODI_JAR2=fmw_${VERSION}_odi2.jar
ENV MYSQL_USER=odi
ENV MYSQL_PASSWORD=Admin123

RUN yum -y install wget which unzip make gcc file sudo
RUN wget -q -O ${JDK_RPM} https://s3.amazonaws.com/software.redpillanalytics.io/oracle/java/${JDK_RPM}
RUN yum -y install ${JDK_RPM}
RUN yum clean all
RUN java -version
RUN rm ${JDK_RPM}

RUN wget -q -O $ODI_JAR https://s3.amazonaws.com/rpa-oracle-software/odi/${VERSION}/${ODI_JAR}
RUN wget -q -O $ODI_JAR2 https://s3.amazonaws.com/rpa-oracle-software/odi/${VERSION}/${ODI_JAR2}
RUN useradd -b /opt -d $ORACLE_BASE -m -s /bin/bash oracle
RUN mkdir -p ${ORACLE_BASE}/container-scripts ${ORACLE_BASE}/logs $ORACLE_HOME
COPY oraInst.loc ${ORACLE_BASE}
COPY container-scripts/* ${ORACLE_BASE}/container-scripts/

RUN chown oracle:oracle -R ${ORACLE_BASE}
RUN chmod a+xr ${ORACLE_BASE}/container-scripts/*.*

USER oracle
RUN java -jar $ODI_JAR -silent -invPtrLoc ${ORACLE_BASE}/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="Standalone Installation"

USER root
RUN rm ${ODI_JAR} ${ODI_JAR2}

