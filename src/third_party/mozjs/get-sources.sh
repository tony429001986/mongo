#!/bin/bash
# This script downloads the sources of SpiderMonkey

set -euo pipefail
IFS=$'\n\t'

set -vx

NAME=spidermonkey

VERSION="115.19.0esr"
LIB_GIT_BRANCH=spidermonkey-esr115.19-cpp-only
LIB_GIT_REVISION=4c197344dfc48dfbbd242333878f17f0379e6205
LIB_GIT_REPO=git@github.com:mongodb-forks/spidermonkey.git

DEST_DIR=$(git rev-parse --show-toplevel)/src/third_party/mozjs

LIB_GIT_DIR=$(mktemp -d /tmp/import-spidermonkey.XXXXXX)
trap "rm -rf $LIB_GIT_DIR" EXIT

git clone $LIB_GIT_REPO $LIB_GIT_DIR
git -C $LIB_GIT_DIR checkout $LIB_GIT_BRANCH
git -C $LIB_GIT_DIR checkout $LIB_GIT_REVISION

test -d $DEST_DIR/mozilla-release && rm -rf $DEST_DIR/mozilla-release
rm -rf $LIB_GIT_DIR/.git
mkdir -p $DEST_DIR/mozilla-release
(shopt -s dotglob; mv $LIB_GIT_DIR/* $DEST_DIR/mozilla-release)
