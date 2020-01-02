FROM  gcr.io/rpa-devops/oxe

ENV JDK=jdk-8u231-linux-x64

ENV JDK_RPM=${JDK}.rpm \
    JAVA_HOME=/usr/java/jdk1.8.0_231-amd64 \
    VERSION=12.2.1.3.0 \
    ORACLE_BASE=/opt/oracle

ENV ODI_HOME=${ORACLE_BASE}/odi1 \
    ODI_AGENT_PORT=20910 \
    DOMAIN_NAME="${DOMAIN_NAME:-base_domain}" \
    DOMAIN_ROOT="${DOMAIN_ROOT:-/u01/oracle/user_projects/domains}" \
    LOG_DIR=${ORACLE_BASE}/logs \
    ORA_INST=oraInst.loc \
    RUN_ODI=runODI.sh \
    CREATE_ODI=CreateODIDomain.py

ENV PATH=$PATH:${ORACLE_BASE}:$ODI_HOME/oracle_common/common/bin:$ODI_HOME/oracle_common/bin:$ODI_HOME/OPatch \
    ODI_JAR=fmw_${VERSION}_odi.jar \
    ORACLE_PWD=Admin123

ENV CONNECTION_STRING=localhost:1521/XEPDB1 \
    HOST_NAME=localhost \
    RCUPREFIX=DEV \
    DB_PASSWORD=$ORACLE_PWD \
    DB_SCHEMA_PASSWORD=$ORACLE_PWD \
    SUPERVISOR_PASSWORD=$ORACLE_PWD \
    WORK_REPO_PASSWORD=$ORACLE_PWD

COPY ${ORA_INST} ${ORACLE_BASE}/

RUN yum -y install which make gcc \
    && curl -o ${JDK_RPM} https://s3.amazonaws.com/software.redpillanalytics.io/oracle/java/${JDK_RPM} \
    && yum -y install ${JDK_RPM} \
    && yum clean all \
    && java -version \
    && rm ${JDK_RPM} \
    && curl -o $ODI_JAR https://s3.amazonaws.com/software.redpillanalytics.io/oracle/odi/${VERSION}/${ODI_JAR} \
    && mkdir -p $LOG_DIR $ODI_HOME \
    && chown oracle:oinstall -R ${ORACLE_BASE} \
    && chmod a+xr $ORACLE_BASE/*.sh

USER oracle
RUN java -jar $ODI_JAR -silent -invPtrLoc ${ORACLE_BASE}/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ODI_HOME INSTALL_TYPE="Standalone Installation"

USER root
WORKDIR /
RUN rm -rf ${ODI_JAR}

COPY ${RUN_ODI} ${CREATE_ODI} ${ORACLE_BASE}/
RUN chown oracle:oinstall -R ${ORACLE_BASE} \
    && chmod a+xr $ORACLE_BASE/*.sh

EXPOSE 20910
EXPOSE 1521

ENTRYPOINT ${ORACLE_BASE}/${RUN_DB} && ${ORACLE_BASE}/${RUN_ODI} && cat
