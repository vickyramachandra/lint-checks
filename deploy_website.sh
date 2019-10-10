#!/bin/bash

# The website is built using MkDocs with the Material theme.
# https://squidfunk.github.io/mkdocs-material/
# It requires Python to run.
# Install the packages with the following command:
# pip install mkdocs mkdocs-material

if [ "$1" = "--local" ]; then local=true; fi
if ! [ $local ]; then
  set -ex

  REPO="git@github.com:uber/lint-checks.git"
  DIR=temp-clone

  # Delete any existing temporary website clone
  rm -rf $DIR

  # Clone the current repo into temp folder
  git clone $REPO $DIR

  # Move working directory into temp folder
  cd $DIR
fi

# Copy in special files that GitHub wants in the project root.
cat README.md > docs/index.md
cp CHANGELOG.md docs/changelog.md
cp CONTRIBUTING.md docs/contributing.md
cp CODE_OF_CONDUCT.md docs/code-of-conduct.md

# Build the site and push the new files up to GitHub
if ! [ $local ]; then
  mkdocs gh-deploy
else
  mkdocs serve
fi

# Delete our temp folder
if ! [ $local ]; then
  cd ..
  rm -rf $DIR
fi
