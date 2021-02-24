#!/bin/bash

if [ $TRAVIS_PULL_REQUEST == "true" ]; then
    exit 0
fi

set -e
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

echo "Updating pokédex..."
ruby pokemongo.rb
echo "Updating projects..."
curl -X GET "https://status.kovuthehusky.com/projects.json" > _data/projects.json

rm -rf _site
mkdir _site
git clone https://${GITHUB_TOKEN}@github.com/KovuTheHusky/kovuthehusky.com.git --branch gh-pages _site
bundle exec jekyll build
cd _site
if [ -n "$(git status --porcelain)" ]; then
    git add --all
    git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
    git push --force origin gh-pages
fi
