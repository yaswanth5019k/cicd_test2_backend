# Multi-stage Dockerfile for carrental-backend
# Build with Maven (Java 21), then run the produced jar on a small JRE image

FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy only the files needed for dependency resolution first for better caching
COPY pom.xml ./
COPY mvnw ./
COPY .mvn .mvn
COPY src ./src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy the built jar from the build stage. Adjust if your build produces a different filename.
COPY --from=build /app/target/*.jar /app/app.jar

EXPOSE 8080
ENV JAVA_OPTS="-Xms256m -Xmx512m"
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]
