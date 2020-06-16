#!/bin/bash

source ".github/base-dockerfile/helpers/tmp-helper.sh"
source ".github/base-dockerfile/helpers/cf-helper.sh"

echo "Prepare CF env for testing"

echo "init"
INSTALL_TIMEOUT=40 #service deploy timeout
branch_name=$(echo $GITHUB_REF | awk -F'/' '{print $3}')
org_name="atlas-test-$branch_name"
make_pcf_metadata $INPUT_PCF_URL $INPUT_PCF_USER $INPUT_PCF_PASSWORD

echo "Login. Create ORG and SPACE depended on the branch name"
cf_login
cf create-org $org_name && cf target -o $org_name
cf create-space $org_name && cf target -s $org_name

echo "Create service-broker"
create_atlas_service_broker_from_repo mongodb-atlas-$branch_name atlas-osb-app-$branch_name

cf marketplace

create_service aws-atlas-test-instance-$branch_name

echo "Simple app"
git clone https://github.com/leo-ri/simple-ruby.git
cd simple-ruby
cf push simple-app-$branch_name --no-start
cf bind-service simple-app-$branch_name aws-atlas-test-instance-$branch_name
cf restart simple-app-$branch_name
check_app_started simple-app-$branch_name
app_url=$(cf app simple-app-$branch_name | awk '$1 ~ /routes:/{print $2}')
echo "::set-output name=app_url::$app_url"

#echo "Prepare app"
#we can hide "prepare app" with
#cf push APP_NAME --docker-image [REGISTRY_HOST:PORT/]IMAGE[:TAG] [--docker-username USERNAME] [-c COMMAND] [-f MANIFEST_PATH | --no-manifest] [--no-start] [-i NUM_INSTANCES] [-k DISK] [-m MEMORY] [-t HEALTH_TIMEOUT] [-u (process | port | http)] [--no-route | --random-route | --hostname HOST | --no-hostname] [-d DOMAIN] [--route-path ROUTE_PATH] [--var KEY=VALUE]... [--vars-file VARS_FILE_PATH]...
# git clone https://github.com/leo-ri/spring-music.git
# cd spring-music
# chmod +x ./gradlew
# ./gradlew clean assemble
# cf push test-app-$branch_name --no-start
# cf set-env test-app-$branch_name JAVA_OPTS "-Dspring.profiles.active=mongodb"
# cf bind-service test-app-$branch_name aws-atlas-test-instance-$branch_name
# cf start test-app-$branch_name

# app_url=$(cf app test-app-$branch_name | awk '$1 ~ /routes:/{print $2}')
# echo "::set-output name=app_url::$app_url"