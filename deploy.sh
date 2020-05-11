#!/bin/bash

if [ $TRAVIS_PULL_REQUEST == "true" ]; then
    exit 0
fi

set -e

if [ $TRAVIS_EVENT_TYPE == "api" ] || [ $TRAVIS_EVENT_TYPE == "cron" ]; then
    git checkout master
    git remote set-url origin https://${GITHUB_TOKEN}@github.com/KovuTheHusky/kovuthehusky.com.git
    ruby places.rb ${FOURSQUARE_TOKEN}
    ruby pokemongo.rb
    ruby projects.rb ${GITHUB_TOKEN}
    if [ -n "$(git diff --quiet)" ]; then
        git add --all
        git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
        git push origin master
    fi
else
    rm -rf _site
    mkdir _site
    git clone https://${GITHUB_TOKEN}@github.com/KovuTheHusky/kovuthehusky.com.git --branch gh-pages _site
    bundle exec jekyll build
    cd _site
    git add --all
    git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
    git push --force origin gh-pages
fi
