# build stages for a Java application using Maven and OpenJDK 17
FROM maven:3.8.5-openjdk-17-slim AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Final stage to create a lightweight image
# using OpenJDK 17 and the built JAR file
FROM openjdk:17-slim
WORKDIR /app
COPY --from=build /app/target/*.jar devops_project.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "devops_project.jar"]
