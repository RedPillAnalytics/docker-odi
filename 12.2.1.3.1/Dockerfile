FROM  r.cfcr.io/redpillanalytics/odi:12.2.1.3.0 as BUILD

RUN yum -y install wget unzip && \
    yum clean all

RUN wget -q -O p26669648_122130_Generic.zip https://s3.amazonaws.com/rpa-oracle-software/odi/12.2.1.3.1/p26669648_122130_Generic.zip  && \
    unzip -q p26669648_122130_Generic.zip && \
    chown oracle:oracle -R 26669648

RUN cd 26669648 && \
    su-exec oracle opatch apply -silent && \
    rm -rf $ORACLE_HOME/.patch_storage

FROM r.cfcr.io/redpillanalytics/jdk:8u211

ENV JAVA_HOME=/usr/java/jdk1.8.0_211-amd64 \
    ORACLE_HOME=/u01/oracle/odi1 \
    ODI_AGENT_PORT=20910 \
    DOMAIN_NAME="${DOMAIN_NAME:-base_domain}" \
    DOMAIN_ROOT="${DOMAIN_ROOT:-/u01/oracle/user_projects/domains}"

ENV PATH=$PATH:$ORACLE_HOME/oracle_common/common/bin:$ORACLE_HOME/container-scripts:$ORACLE_HOME/OPatch \
    DOMAIN_HOME=$DOMAIN_ROOT/$DOMAIN_NAME

RUN mkdir /u01 && \
    useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle

COPY --from=BUILD /u01 /u01
COPY --from=BUILD /usr/bin/su-exec /usr/bin/su-exec

RUN chown oracle:oracle -R /u01 && \
    chmod a+xr /u01
