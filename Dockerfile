# Built by .github/workflows/deploy.yml (context ., file Dockerfile) and pushed
# to Artifact Registry.
#
# A job image, not a server: the default command runs the JUnit suite
# (`mvn test`, offline) and exits 0 when it passes, non-zero when a test fails.
# It will never satisfy a $PORT health check. Maven stays in the image because
# running the suite IS the job; the build warms the local repository (every
# dependency and plugin, by running the suite once) as the non-root user.
FROM maven:3.9-eclipse-temurin-21
ARG BUILD_ID=""
ENV BUILD_ID=$BUILD_ID MAVEN_CONFIG=/home/app/.m2
RUN useradd -m -u 10001 app
WORKDIR /app
RUN chown app /app
USER app
COPY --chown=app pom.xml ./
RUN mvn -B -q dependency:go-offline
COPY --chown=app src ./src
RUN mvn -B -ntp test
ENTRYPOINT []
CMD ["mvn", "-B", "-ntp", "-o", "test"]
