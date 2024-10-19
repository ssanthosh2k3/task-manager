# Stage 1: Build the application
FROM maven:3.8.6-jdk-17-slim AS build

# Set the working directory
WORKDIR /usr/src/app

# Copy the pom.xml and source code
COPY pom.xml ./
COPY src ./src

# Package the application
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM amazoncorretto:17.0.8-alpine3.18

# Set the environment variable for the application home
ENV APP_HOME /usr/src/app

# Expose the application port
EXPOSE 8080

# Copy the jar from the build stage
COPY --from=build /usr/src/app/target/*.jar $APP_HOME/app.jar

# Set the working directory
WORKDIR $APP_HOME

# Command to run the application
CMD ["java", "-jar", "app.jar"]
