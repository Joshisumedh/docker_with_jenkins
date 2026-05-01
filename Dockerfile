FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY HelloWorld.class .
CMD ["java", "HelloWorld"]
