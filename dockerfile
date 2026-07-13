FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM tomcat:10.1-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/cat-grooming.war /usr/local/tomcat/webapps/ROOT.war
CMD sh -c "sed -i \"s/8080/\${PORT:-8080}/g\" /usr/local/tomcat/conf/server.xml && catalina.sh run"
