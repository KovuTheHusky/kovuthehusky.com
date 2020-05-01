#!/bin/bash

if [ $TRAVIS_PULL_REQUEST == "true" ]; then
    exit 0
fi

set -e
git config user.email "kovuthehusky@gmail.com"
git config user.name "KovuTheHusky"

if [ $TRAVIS_EVENT_TYPE == "cron" ]; then
    ruby places.rb ${FOURSQUARE_TOKEN}
    ruby pokemongo.rb
    ruby projects.rb
    git add --all
    git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
    git push origin master
else
    rm -rf _site
    mkdir _site
    git clone https://${GITHUB_TOKEN}@github.com/KovuTheHusky/kovuthehusky.com.git --branch gh-pages _site
    yarn
    bundle exec jekyll build
    cd _site
    git add --all
    git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
    git push --force origin gh-pages
fi
