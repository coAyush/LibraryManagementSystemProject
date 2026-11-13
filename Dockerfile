# Multi-stage Dockerfile for Library Management System
# Compatible with Docker Compose, Render, Railway, AWS, and GCP

# Stage 1: Build WAR with Maven
FROM maven:3.9-eclipse-temurin-11 AS builder
WORKDIR /app

# Copy dependency configs and local libs first for caching
COPY pom.xml .
COPY lib ./lib

# Copy source code and web content
COPY src ./src
COPY web ./web

# Package the webapp
RUN mvn clean package -DskipTests

# Stage 2: Run Tomcat 9
FROM tomcat:9.0-jre11-temurin

# Clean default Tomcat web applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy as ROOT application (accessible directly at /)
COPY --from=builder /app/target/LibraryManagementSystem /usr/local/tomcat/webapps/ROOT

# Also deploy at /LibraryManagementSystem (for backwards-compatibility)
COPY --from=builder /app/target/LibraryManagementSystem /usr/local/tomcat/webapps/LibraryManagementSystem

# Ensure write permissions for file uploads (pdf) and generated receipts (Issue)
RUN chmod -R 777 /usr/local/tomcat/webapps/

# Memory optimization for Render / cloud free tiers (512MB RAM limit)
ENV JAVA_OPTS="-Xms128m -Xmx384m -XX:+UseSerialGC -Djava.awt.headless=true"

# Expose default port
EXPOSE 8080

# Dynamically bind to Render/Railway $PORT if set (otherwise default to 8080)
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/g\" /usr/local/tomcat/conf/server.xml && exec catalina.sh run"]
