# Start from GridGain Professional image.
FROM gridgain/gridgain-pro:8.7.6

# Set config uri for node.
ENV CONFIG_URI sqlJoin-server.xml

# Copy optional libs.
ENV OPTION_LIBS ignite-rest-http

# Update packages and install maven.
RUN set -x \
    && apk add --no-cache \
        openjdk8

RUN apk --update add \
    maven \
    && rm -rfv /var/cache/apk/*

# Append project to container.
ADD . sqlJoin

# Build project in container.
RUN mvn -f sqlJoin/pom.xml clean package -DskipTests

# Copy project jars to node classpath.
RUN mkdir $IGNITE_HOME/libs/sqlJoin && \
   find sqlJoin/target -name "*.jar" -type f -exec cp {} $IGNITE_HOME/libs/sqlJoin \;