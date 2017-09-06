#!/usr/bin/env groovy

def REGISTRY = 'myLocalDockerRegistry:5005'
def ORGANIZATION = 'myOrganization'
def NAME = 'docker-bench-security'
def VERSION = '1.3.3'
def RELEASE_VERSION = '1.0'
def IMAGE_NAME_AND_TAG = "${ORGANIZATION}/${NAME}:${VERSION}-${RELEASE_VERSION}"

try {
    node('docker') {

        stage('Checkout') {
            checkout scm
            sh 'git status'
            sh 'printenv'
            sh 'pwd'
            sh 'tree -hv'
            
        }

        def image

        stage('Build') {
            image = docker.build(IMAGE_NAME_AND_TAG, ''
                    + '--build-arg BRANCH_NAME="${BRANCH_NAME}" '
                    + '--build-arg COMMIT_ID="$(git rev-parse HEAD)" '
                    + '--build-arg BUILD_ID="${BUILD_ID}" '
                    + '--build-arg JENKINS_URL="${JENKINS_URL}" '
                    + '--build-arg JOB_NAME="${JOB_NAME}" '
                    + '--build-arg NODE_NAME="${NODE_NAME}" '
                    + '.')
        }

        stage('Push') {
            docker.withRegistry(
                    "https://${REGISTRY}",
                    'docker-registry_docker-user-and-password') {
                image.push()
            }
        }

        stage('Remove') {
            sh("docker image rm ${IMAGE_NAME_AND_TAG} ${REGISTRY}/${IMAGE_NAME_AND_TAG}")
        }
    }
} catch (ex) {
    // If there was an exception thrown, the build failed
    if (currentBuild.result != "ABORTED") {
        // Send e-mail notifications for failed or unstable builds.
        // currentBuild.result must be non-null for this step to work.
        emailext(
                recipientProviders: [
                        [$class: 'DevelopersRecipientProvider'],
                        [$class: 'RequesterRecipientProvider']],
                subject: "Job '${env.JOB_NAME}' - Build ${env.BUILD_DISPLAY_NAME} - FAILED!",
                body: """<p>Job '${env.JOB_NAME}' - Build ${env.BUILD_DISPLAY_NAME} - FAILED:</p>
                        <p>Check console output &QUOT;<a href='${env.BUILD_URL}'>${env.BUILD_DISPLAY_NAME}</a>&QUOT;
                        to view the results.</p>"""
        )
    }

    // Must re-throw exception to propagate error:
    throw ex
}
