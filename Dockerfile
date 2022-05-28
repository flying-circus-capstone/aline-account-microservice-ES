FROM adoptopenjdk/openjdk11:jre-11.0.9.1_1-alpine@sha256:b6ab039066382d39cfc843914ef1fc624aa60e2a16ede433509ccadd6d995b1f

ENV APP_PORT=8072
EXPOSE ${APP_PORT}

RUN apk add dumb-init
RUN mkdir /app
RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser
COPY /account-microservice/target/*.jar /app/account-microservice.jar
WORKDIR /app
RUN chown -R javauser:javauser /app
USER javauser

CMD "dumb-init" "java" "-jar" "account-microservice.jar"