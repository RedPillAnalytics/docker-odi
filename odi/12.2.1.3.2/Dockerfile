FROM odi:12.2.1.3.0 as BUILD

RUN yum -y install wget unzip && \
    yum clean all

RUN wget -q -O p26669648_122130_Generic.zip https://s3.amazonaws.com/rpa-checkmate-resources/odi/12.2.1.3.181204/software/p26669648_122130_Generic.zip  && \
    unzip -q p26669648_122130_Generic.zip && \
    chown oracle:oracle -R 26669648

RUN cd 26669648 && \
    su-exec oracle opatch apply -silent

FROM jdk:8u211
COPY --from=BUILD ${ORACLE_HOME} ${ORACLE_HOME}
COPY --from=BUILD /usr/bin/su-exec /usr/bin/.
