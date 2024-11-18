#!/bin/bash
echo "--Build Started--"
echo "--Check run in bash--"
if [ "$BASH" != "/bin/bash" ]; then
    echo "Требуется запускать скрипт в bash"
    exit 1
fi
set -e 
#Git
GIT_EMAIL="testdevelop@mail.ru"
GIT_NAME="test"
GIT_REPOS="git@github.com:ZhdArtemiy/develop.git"
GIT_KEY64="c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFDQVFEb3JycFBDMzIzMzIxTGFaNE5KZDRCMytKYVpRNGlqMnZ1clp4eGpTUUlXaTF2VWVtaXlQQWErRS9QeGJPTURFZGVGTWM2WUFSWCtNSGZUWVk2OTZvaGtPYi9DUkJpSTh3Njh1SWo1VllLZGViTzU1bGxwY1dXN0FidnRZL2pUM0FOZ1ZINFNuWThNZVg3SXUxMFhBMXprTDN3UVNRdk02TGNrZncrbGRTdG1lS2tjcEVsY25IcHNMcmc5dWlVSTBxOFhYZXZVYlZPWnRTaTVxb3BwclE0R2wvb2V0MjV1L0JHNTFYQStjSEkrM2V6RzVXNXFySmY2SXBNY1V5am50YmlDNTMyaEx6REl1STRidllzZUdIZm9YaWpQREFtdWxYWjhQajNkRUM1ZFZMVjhjdTVsYzhuNll6OU90b1pPa0VyRWNvTk4reWJyemRlS21QYjRHZVVkV1F3eFBNaGlGaVlSemMzS0c1blVBTnlBalZ4U0FuK0huZkpnNWxMM0xpNDk4TlRFd2dKM1FBS2gwRG51aEI1am1ieU1QOGRuMWdDMG00MU5jWFl3U2FzL2poV2ozT0Q3c1VJNjhqYkJXWWMxWGV3N2k5NzVjY3diVU8rVk1QY2hobmpRd0NjRXdaclhLTTh2bXA3dGpkZ1JaZmhmUk40NVFPczdrZnV3andPdlpuS0ZraW0wZWFFRHBsMUZhZDlMNjJEVG1nSmlnRFZoYzFMUDc3YU1sQkozUmV1L3NlSHVqRS9lUStHL283REpWQkt3ak0vcUJoUW1JZGR0S3Frb1g1aSsrcW9vNjdLemh6b3RaTGNmREduKzNEZzdEUVpYbGdGZ3BlUWlndGdEVUgvekN1UUVoRksrd1BGTGY0dzB0QmllRjNJY1IrZ3BMVGowdy9aOVE9PSB0ZW1hemhkYW5vdjI4NEBnbWFpbC5jb20="
GIT_KEY="$(echo "$GIT_KEY64" | base64 --decode)"
GIT_BRANCH="develop"
GIT_DIR="build-$(date +"%d:%m:%Y")-branch:$GIT_BRANCH"
echo "$GIT_KEY" > ~/.ssh/id_rsa
git config --global user.email $email
git config --global user.name $name
git remote add origin $git_repos_develop
#Dep
mkdir $GIT_DIR && cd $GIT_DIR
git clone --branch $GIT_BRANCH $GIT_REPOS .
