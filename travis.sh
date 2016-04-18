#!/bin/bash
set -ev

GH_SONARQ_PARAMS=""

# When run on Travis CI, env var TRAVIS_PULL_REQUEST either contains PR number (for PR builds) or "false" (for push builds).
# Locally this env var is not set. Test: if variable is not empty and is not equal "false"
if [ ! -z "$TRAVIS_PULL_REQUEST" ] && [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
    echo "PR build. Will execute SonarQube preview scan"
    GH_SONARQ_PARAMS="jacocoTestReport sonarqube -Dsonar.analysis.mode=preview -Dsonar.host.url=$SQ_URL -Dsonar.github.oauth=$GH_TOKEN -Dsonar.github.repository=$TRAVIS_REPO_SLUG -Dsonar.github.pullRequest=$TRAVIS_PULL_REQUEST"
fi

if [ "${TRAVIS_PULL_REQUEST}" == "false" ] && [ "${TRAVIS_BRANCH}" == "build/removal-of-jenkins" ]; then
    echo "Building $TRAVIS_BRANCH branch. Will execute SonarQube scan"
    GH_SONARQ_PARAMS="jacocoTestReport sonarqube -Dsonar.host.url=$SQ_URL -Dsonar.jdbc.url=$SQ_JDBC_URL -Dsonar.jdbc.driverClassName=org.postgresql.Driver -Dsonar.jdbc.user=$SQ_JDBC_USER -Dsonar.jdbc.password=$SQ_JDBC_PASSWORD"
fi

./gradlew --info --stacktrace clean build $GH_SONARQ_PARAMS

