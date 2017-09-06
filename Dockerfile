FROM alpine:3.6

LABEL org.label-schema.name="docker-bench-security" \
      org.label-schema.url="https://dockerbench.com" \
      org.label-schema.vcs-url="https://github.com/docker/docker-bench-security.git"

ARG JENKINS_URL
ARG NODE_NAME
ARG JOB_NAME
ARG BRANCH_NAME
ARG COMMIT_ID
ARG BUILD_ID

LABEL jenkins.url="${JENKINS_URL}"
LABEL node.name="${NODE_NAME}"
LABEL job.name="${JOB_NAME}"
LABEL branch.name="${BRANCH_NAME}"
LABEL commit.id="${COMMIT_ID}"
LABEL build.id="${BUILD_ID}"

RUN \
  apk upgrade --no-cache && \
  apk add --no-cache \
    docker \
    dumb-init && \
  rm -rf /usr/bin/docker-* /usr/bin/dockerd && \
  mkdir /usr/local/bin/tests

COPY ./*.sh /usr/local/bin/

COPY ./tests/*.sh /usr/local/bin/tests/

WORKDIR /usr/local/bin

HEALTHCHECK CMD exit 0

ENTRYPOINT [ "/usr/bin/dumb-init", "docker-bench-security.sh" ]

