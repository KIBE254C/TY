FROM gradle:5.4.1-jdk-alpine as builder
USER root
COPY . /project
WORKDIR /project
RUN gradle bootJar

FROM openjdk:20-ea-jdk-slim
RUN apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get -y install fontconfig \
    && apt-get -y install fonts-dejavu-core \
    && apt-get -y install tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* $HOME/.cache
COPY --from=builder /project/build/libs/website-0.0.1.jar /project/    
EXPOSE 8080
ENTRYPOINT java -Xms256M -Xmx768M -jar /project/website-0.0.1.jar
