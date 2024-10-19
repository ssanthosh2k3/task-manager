# Use an available Maven image with OpenJDK
FROM maven:3.9.4-openjdk-11 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src

# Package the application
RUN mvn clean package

# Use OpenJDK to run the application
FROM openjdk:11-jre-slim
COPY --from=build /app/target/*.jar app.jar

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
