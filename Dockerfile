# Use an OpenJDK image as the base
FROM openjdk:21-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Java source file into the container
COPY HelloWorld.java .

# Compile the Java program inside the container
RUN javac HelloWorld.java

# Run the application when the container starts
CMD ["java", "HelloWorld"]
