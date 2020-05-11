#!/bin/bash

if [ $TRAVIS_PULL_REQUEST == "true" ]; then
    exit 0
fi

set -e
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

git checkout master
git remote set-url origin https://${GITHUB_TOKEN}@github.com/KovuTheHusky/kovuthehusky.com.git
echo "Updating places..."
ruby places.rb ${FOURSQUARE_TOKEN}
echo "Updating pokédex..."
ruby pokemongo.rb
echo "Updating projects..."
ruby projects.rb ${GITHUB_TOKEN}
chmod -x deploy.sh
if [ -n "$(git status --porcelain)" ]; then
    git add --all
    git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
    git push origin master
fi

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
