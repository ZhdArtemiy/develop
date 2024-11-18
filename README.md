# develop

#Pipliene Artemiy Zhdanov
#
image: docker:27.3.1-alpine3.20

services:
  - docker:dind

stages:
    - stage_build
    - stage_test
    - stage_deploy
    - stage_status

variables:
    LOG_PIPLIENE: $CI_COMMIT_BRANCH:$CI_COMMIT_AUTHOR:$CI_COMMIT_TIMESTAMP.txt
    YII_DIR: "build-$(date +'%d-%m-%Y')-branch:$GIT_BRANCH"
    GIT_BRANCH: "develop"

default:
    artifacts:
        patch:
            - $LOG_PIPLIENE
            - $YII_DIR

before_script:
  - echo "[${CI_JOB_STARTED_AT}] --Check run in bash--"
  - if [[ ! -x /bin/bash ]]; then
      echo "[${CI_JOB_STARTED_AT}] --Execute only in bash--"
      exit 1
    fi
  - set -e

job_build:
    stage: stage_build
    rules:
        - if: '$CI_COMMIT_BRANCH == "develop"'
    variables:
        GIT_EMAIL: "testdevelop@mail.ru"
        GIT_NAME: "test"
        GIT_REPOS: "git@github.com:ZhdArtemiy/develop.git"
        GIT_KEY64: "c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFDQVFEb3JycFBDMzIzMzIxTGFaNE5KZDRCMytKYVpRNGlqMnZ1clp4eGpTUUlXaTF2VWVtaXlQQWErRS9QeGJPTURFZGVGTWM2WUFSWCtNSGZUWVk2OTZvaGtPYi9DUkJpSTh3Njh1SWo1VllLZGViTzU1bGxwY1dXN0FidnRZL2pUM0FOZ1ZINFNuWThNZVg3SXUxMFhBMXprTDN3UVNRdk02TGNrZncrbGRTdG1lS2tjcEVsY25IcHNMcmc5dWlVSTBxOFhYZXZVYlZPWnRTaTVxb3BwclE0R2wvb2V0MjV1L0JHNTFYQStjSEkrM2V6RzVXNXFySmY2SXBNY1V5am50YmlDNTMyaEx6REl1STRidllzZUdIZm9YaWpQREFtdWxYWjhQajNkRUM1ZFZMVjhjdTVsYzhuNll6OU90b1pPa0VyRWNvTk4reWJyemRlS21QYjRHZVVkV1F3eFBNaGlGaVlSemMzS0c1blVBTnlBalZ4U0FuK0huZkpnNWxMM0xpNDk4TlRFd2dKM1FBS2gwRG51aEI1am1ieU1QOGRuMWdDMG00MU5jWFl3U2FzL2poV2ozT0Q3c1VJNjhqYkJXWWMxWGV3N2k5NzVjY3diVU8rVk1QY2hobmpRd0NjRXdaclhLTTh2bXA3dGpkZ1JaZmhmUk40NVFPczdrZnV3andPdlpuS0ZraW0wZWFFRHBsMUZhZDlMNjJEVG1nSmlnRFZoYzFMUDc3YU1sQkozUmV1L3NlSHVqRS9lUStHL283REpWQkt3ak0vcUJoUW1JZGR0S3Frb1g1aSsrcW9vNjdLemh6b3RaTGNmREduKzNEZzdEUVpYbGdGZ3BlUWlndGdEVUgvekN1UUVoRksrd1BGTGY0dzB0QmllRjNJY1IrZ3BMVGowdy9aOVE9PSB0ZW1hemhkYW5vdjI4NEBnbWFpbC5jb20="
        GIT_KEY: "$(echo "$GIT_KEY64" | base64 --decode)"
    script:
        - echo "[${CI_JOB_STARTED_AT}] --BUILD STARTED--"
        - echo "[${CI_JOB_STARTED_AT}] --GIT PULL IMAGE--"
        - echo "$GIT_KEY" > ~/.ssh/id_rsa
        - if [ -f ~/.ssh/id_rsa ]; then chmod 600 ~/.ssh/id_rsa; fi
        - git config --global user.email $GIT_EMAIL
        - git config --global user.name $GIT_NAME
        - git remote add origin $GIT_REPOS
        - mkdir -p $YII_DIR && cd $YII_DIR
        - git clone --branch $GIT_BRANCH $GIT_REPOS .
        - echo "[${CI_JOB_STARTED_AT}] --START DOCKER BUILD & RUN--"
        - docker-compose up -d --build &>> $LOG_PIPLIENE
        - echo "[${CI_JOB_STARTED_AT}] --RESULT:${LOG_PIPLIENE}--"

job_test:
    stage: stage_test
    variables:       
        YII_ENV: "test"
        DB_DSN: "mysql:host=localhost;dbname=yii2basic"  
        DB_USER64: "eWlpdGVzdA=="  
        DB_PASS64: "eWlpMmJhc2ljX3Bhc3N3b3Jk"  
        MYSQL_DATABASE: yii2basic
        MYSQL_USER: "$(echo "$DB_USER64" | base64 --decode)"
        MYSQL_PASSWORD: "$(echo "$DB_PASS64" | base64 --decode)"
    script:
        - echo "[${CI_JOB_STARTED_AT}] --TEST STARTED--"
        - cd $YII_DIR
        - echo "[${CI_JOB_STARTED_AT}] --COUNT CODECEPTION TEST $(find $YII_DIR/tests/ -name '*.php' | wc -l )\n $(find $YII_DIR/tests/ -name '*.php' | wc -l )--"
        - echo "[${CI_JOB_STARTED_AT}] --RUN CODECEPTION TESTS--"
        - vendor/bin/codecept run &>> $LOG_PIPLIENE

job_deploy:
    stage: stage_deploy
    script: 

job_result:
    stage: stage_status
    script:
      - echo "[${CI_JOB_STARTED_AT}]--STATUS\n $LOG_PIPLIENE--"    
