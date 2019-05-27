FROM  r.cfcr.io/redpillanalytics/odi:12.2.1.3.0 as BUILD

ENV PATCH=29643497 \
    VERSION=12.2.1.3.2

RUN wget -q -O p${PATCH}_122130_Generic.zip https://s3.amazonaws.com/rpa-oracle-software/odi/${VERSION}/p${PATCH}_122130_Generic.zip  && \
    unzip -q p${PATCH}_122130_Generic.zip && \
    chown oracle:oracle -R ${PATCH}

RUN cd ${PATCH} && \
    /bin/bash -c "while true; do echo Keep alive... && sleep 600; done &" && \
    su-exec oracle opatch apply -silent -verbose && \
    rm -rf $ORACLE_HOME/.patch_storage && \
    cd / && \
    rm -rf ${PATCH} p${PATCH}_122130_Generic.zip
