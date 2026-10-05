# JUnit 5 template

Provisioned from [`Qode-Fleet-Control/fleet-template-v1`](https://github.com/Qode-Fleet-Control/fleet-template-v1) — the fleet
lifecycle contract (`bin/`, `fleet.conf`, deploy workflows) with a
JUnit 5 (Jupiter) testing starter laid on top.

JUnit 5.14 (Jupiter) with Maven Surefire: a `Calculator` under test and a suite showing `@Test`, `@DisplayName` and `@ParameterizedTest` with `@CsvSource`. The job is the suite — `mvn test`.

## Origin

The JUnit team's official Maven starter, `junit-jupiter-starter-maven` from
[junit-team/junit-examples](https://github.com/junit-team/junit-examples) at tag `r5.14.4`
(JUnit has no generator; this is the starter its user guide points to), fetched 2026-10-05:

    R=https://raw.githubusercontent.com/junit-team/junit-examples/r5.14.4/junit-jupiter-starter-maven
    for f in .gitignore .mvn/wrapper/maven-wrapper.properties README.md mvnw mvnw.cmd pom.xml \
             src/main/java/com/example/project/Calculator.java \
             src/test/java/com/example/project/CalculatorTests.java; do
      mkdir -p "$(dirname "$f")"; curl -sf "$R/$f" -o "$f"; done

JUnit 6 continues the same Jupiter API; moving up is a `junit-bom` version bump.

## Verified

**Not yet verified end to end on docker.** On 2026-10-05 the shared docker host's disk sat at
0-1 GB free for over 90 minutes (other builds were running), under the 6 GB floor this
scaffold's verification requires, so the `docker compose` build/run check was not run.
Run it before trusting the image:

    docker compose build && docker compose run --rm app              # must exit 0

What did pass, on 2026-10-05:

- `mvn -B package` **with the test suite** in `maven:3.9-eclipse-temurin-21` (the Dockerfile's
  build image) — compiles, tests green, artifacts produced.

## Run it

**This repo is not a service.** It is a job: the image's default command runs the test suite (`mvn -o test`, offline — the build already fetched everything)
and exits 0 on success (non-zero on failure). `START_CMD` and `DOCKER_START_CMD`
are empty and nothing listens on `$PORT`, so on the fleet `bin/run` builds the
image and stops there.

**With docker:**

    docker compose build
    docker compose run --rm app          # runs the job

**Without docker** — a JDK on `PATH`; `./mvnw` (the starter's Maven wrapper) fetches Maven itself:

| step | command |
|---|---|
| install | `./mvnw -B -q dependency:go-offline` |
| build | `./mvnw -B -q test-compile` |
| run the job | `./mvnw test` |

If you add an HTTP endpoint, listen on `0.0.0.0:$PORT` and serve at `/`, then set
`PORT`, `HEALTH_PATH`, `START_CMD` and `DOCKER_START_CMD` in `fleet.conf` and
publish the port in `compose.yaml` (see the HTTP templates).

## Layout

- `src/main/java/com/example/project/Calculator.java` — the code under test.
- `src/test/java/com/example/project/CalculatorTests.java` — the suite.
- `pom.xml` — `junit-bom` 5.14.4, `junit-jupiter`, Surefire 3.5.4 (all stock).

## What differs from stock output

- None in the starter's code or `pom.xml`.
- `.gitignore`: dropped the stock Eclipse `/bin/` entry (it would ignore the fleet's `bin/` scripts) and appended the fleet entries.
- The `Dockerfile` keeps Maven in the runtime image, because running the suite is the job; it runs the suite once at build time as the non-root user to warm the local repository, so the job runs offline.
- Added the fleet harness: `bin/`, `fleet.conf`, `Dockerfile`, `compose.yaml`, `.dockerignore`, `.github/workflows/`, `docs/fleet-lifecycle.md`.

---

# junit-jupiter-starter-maven

The `junit-jupiter-starter-maven` project demonstrates how to execute JUnit Jupiter
tests using Maven.

Please note that this project uses the [Maven Wrapper](https://github.com/apache/maven-wrapper).
Thus, to ensure that the correct version of Maven is used, invoke `mvnw` instead of `mvn`.
