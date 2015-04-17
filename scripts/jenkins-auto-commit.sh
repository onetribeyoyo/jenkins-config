#!/bin/bash -e

JENKINS_HOME="/Users/Shared/Jenkins/Home"
if [ ! -d "${JENKINS_HOME}" ] || [ ! -f "${JENKINS_HOME}/secret.key" ]; then
    echo "ERROR: Invalid JENKINS_HOME specified: ${JENKINS_HOME}"
    exit 1
fi

echo ''
echo "Running: checking ${JENKINS_HOME} for changes to commit and push..."
echo ''
cd $JENKINS_HOME

echo "--------------------------------------------------------"
echo "Uncommitted changes:"
echo "--------------------------------------------------------"
git status
echo ''

git add -u
git add .

CHANGES_TO_BE_COMMITTED=$(git status | grep "^# Changes to be committed:" | wc -l)

if [ $CHANGES_TO_BE_COMMITTED -eq 0 ]; then
    echo "--------------------------------------------------------"
    echo "Nothing to commit"
    echo "--------------------------------------------------------"
    echo ''
else
    echo "--------------------------------------------------------"
    echo "Changes staged (that will be committed and pushed)"
    echo "--------------------------------------------------------"
    git status
    echo ''
    echo "--------------------------------------------------------"
    echo "Committing and Pushing..."
    echo "--------------------------------------------------------"
    git commit -m "Automated commit of Jenkins configuration at $(date)"
    git push origin master
    echo ''
fi

echo "--------------------------------------------------------"
echo "Uncommitted changes (intentionally not committed):"
echo "--------------------------------------------------------"
git status
echo ''
