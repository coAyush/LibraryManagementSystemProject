# Multi-stage Dockerfile for Library Management System

# Stage 1: Build WAR with Maven
FROM maven:3.9-eclipse-temurin-11 AS builder
WORKDIR /app

# Copy dependency configs and local libs first for caching
COPY pom.xml .
COPY lib ./lib

# Copy source code and web content
COPY src ./src
COPY web ./web

# Package the WAR
RUN mvn clean package -DskipTests

# Stage 2: Run Tomcat 9
FROM tomcat:9.0-jre11-temurin

# Clean default Tomcat web applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy as ROOT application (accessible at /)
COPY --from=builder /app/target/LibraryManagementSystem.war /usr/local/tomcat/webapps/ROOT.war

# Also keep /LibraryManagementSystem mapping for backwards-compatibility
COPY --from=builder /app/target/LibraryManagementSystem.war /usr/local/tomcat/webapps/LibraryManagementSystem.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
