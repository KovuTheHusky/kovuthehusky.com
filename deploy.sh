#!/bin/bash

set -e
cd _site

git init
git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git add .
git commit -m "${GITHUB_RUN_NUMBER}"
git push --force https://KovuTheHusky:${{secrets.JEKYLL_PAT}}@github.com/${GITHUB_REPOSITORY}.git master:gh-pages
