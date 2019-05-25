FROM  r.cfcr.io/redpillanalytics/odi:12.2.1.3.0 as BUILD

RUN yum -y install wget unzip && \
    yum clean all

RUN wget -q -O p26669648_122130_Generic.zip https://s3.amazonaws.com/rpa-oracle-software/odi/12.2.1.3.1/p26669648_122130_Generic.zip  && \
    unzip -q p26669648_122130_Generic.zip && \
    chown oracle:oracle -R 26669648

RUN cd 26669648 && \
    su-exec oracle opatch apply -silent && \
    rm -rf $ORACLE_HOME/.patch_storage
