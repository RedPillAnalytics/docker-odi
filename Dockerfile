FROM  gcr.io/rpa-devops/oxe

ENV JDK=jdk-8u231-linux-x64
ENV JDK_RPM=${JDK}.rpm
ENV JAVA_HOME=/usr/java/jdk1.8.0_231-amd64
ENV VERSION=12.2.1.3.0
ENV ORACLE_BASE=/opt/oracle
ENV ODI_HOME=${ORACLE_BASE}/odi1
ENV ODI_AGENT_PORT=20910
ENV DOMAIN_NAME="${DOMAIN_NAME:-base_domain}"
ENV DOMAIN_ROOT="${DOMAIN_ROOT:-/u01/oracle/user_projects/domains}"
ENV LOG_DIR=${ORACLE_BASE}/logs
ENV ORA_INST=oraInst.loc
ENV RUN_ODI=runODI.sh
ENV CREATE_ODI=CreateODIDomain.py

ENV PATH=$PATH:${ORACLE_BASE}:$ODI_HOME/oracle_common/common/bin:$ODI_HOME/oracle_common/bin:$ODI_HOME/OPatch
ENV ODI_JAR=fmw_${VERSION}_odi.jar
ENV ODI_JAR2=fmw_${VERSION}_odi2.jar
ENV ORACLE_PWD=Admin123

ENV CONNECTION_STRING=localhost:1521/XEPDB1
ENV HOST_NAME=localhost
ENV RCUPREFIX=odi1
ENV DB_PASSWORD=$ORACLE_PWD
ENV DB_SCHEMA_PASSWORD=$ORACLE_PWD
ENV SUPERVISOR_PASSWORD=$ORACLE_PWD
ENV WORK_REPO_PASSWORD=$ORACLE_PWD

RUN yum -y install which make gcc
RUN curl -o ${JDK_RPM} https://s3.amazonaws.com/software.redpillanalytics.io/oracle/java/${JDK_RPM}
RUN yum -y install ${JDK_RPM}
RUN yum clean all
RUN java -version
RUN rm ${JDK_RPM}

RUN curl -o $ODI_JAR https://s3.amazonaws.com/rpa-oracle-software/odi/${VERSION}/${ODI_JAR}
RUN curl -o $ODI_JAR2 https://s3.amazonaws.com/rpa-oracle-software/odi/${VERSION}/${ODI_JAR2}
RUN mkdir -p $LOG_DIR $ODI_HOME
COPY ${ORA_INST} ${ORACLE_BASE}/

RUN chown oracle:oinstall -R ${ORACLE_BASE}
RUN chmod a+xr $ORACLE_BASE/*.sh

USER oracle
RUN java -jar $ODI_JAR -silent -invPtrLoc ${ORACLE_BASE}/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ODI_HOME INSTALL_TYPE="Standalone Installation"

USER root
RUN rm ${ODI_JAR} ${ODI_JAR2}

COPY ${RUN_ODI} ${CREATE_ODI} ${ORACLE_BASE}/
RUN chown oracle:oinstall -R ${ORACLE_BASE}
RUN chmod a+xr $ORACLE_BASE/*.sh
ENTRYPOINT ${ORACLE_BASE}/${RUN_DB} && ${ORACLE_BASE}/${RUN_ODI} && cat
