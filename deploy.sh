#!/bin/bash

if [ $TRAVIS_PULL_REQUEST == "true" ]; then
    exit 0
fi

set -e

rm -rf _site
mkdir _site

git clone https://${GITHUB_TOKEN}@github.com/KovuTheHusky/kovuthehusky.com.git --branch gh-pages _site

yarn
bundle exec jekyll build

cd _site
ruby places.rb ${FOURSQUARE_TOKEN}
git config user.email "kovuthehusky@gmail.com"
git config user.name "KovuTheHusky"
git add --all
git rm -rf *.exe
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --force origin gh-pages
