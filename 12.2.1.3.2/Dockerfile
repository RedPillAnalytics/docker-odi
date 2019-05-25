FROM  r.cfcr.io/redpillanalytics/odi:12.2.1.3.0 as BUILD

RUN yum -y install wget unzip && \
    yum clean all

RUN wget -q -O p29643497_122130_Generic.zip https://s3.amazonaws.com/rpa-oracle-software/odi/12.2.1.3.2/p29643497_122130_Generic.zip  && \
    unzip -q p29643497_122130_Generic.zip && \
    chown oracle:oracle -R 29643497

RUN cd 29643497 && \
    su-exec oracle opatch apply -silent && \
    rm -rf $ORACLE_HOME/.patch_storage
