# Stage 1: Build the plugin
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app
COPY . .

RUN mvn clean package -DskipTests

# Stage 2: Run Jenkins with the built plugin
FROM jenkins/jenkins:lts

USER root
# Install any OS dependencies (if needed)
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Switch back to Jenkins user
USER jenkins

# Copy the plugin (HPI file) to Jenkins plugins directory
COPY --from=builder /app/target/*.hpi /usr/share/jenkins/ref/plugins/

# Preload plugins at startup
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Jenkins runs on port 8080
EXPOSE 8080
