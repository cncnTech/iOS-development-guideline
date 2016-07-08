#!/bin/sh

#  versioningFromGitTag.sh
#  Mansinthe
#
#  Created by Euan Chan on 8/14/15.
#  Copyright (c) 2015 cncn.com. All rights reserved.
#
#  This script automatically sets the version and short version string of
#  an Xcode project from the Git repository containing the project.
#
#  To use this script in Xcode 4, add the contents to a "Run Script" build
#  phase for your application target.

set -o errexit
set -o nounset

# First, check for git in $PATH
hash git 2>/dev/null || { echo >&2 "Git required, not installed.  Aborting build number update script."; exit 0; }

# Alternatively, we could use Xcode's copy of the Git binary,
# but old Xcodes don't have this.
#GIT=$(xcrun -find git)

# Run Script build phases that operate on product files of the target
# that defines them should use the value of this build setting
# [TARGET_BUILD_DIR]. But Run Script build phases that operate on product
# files of other targets should use “BUILT_PRODUCTS_DIR” instead.
INFO_PLIST="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

# Build version (closest-tag-or-branch "-" commits-since-tag "-" short-hash dirty-flag)
BUILD_VERSION=$(git describe --tags --always --dirty=+)

# Use the latest tag for short version (expected tag format "n[.n[.n]]")
LATEST_TAG=$(git describe --tags --abbrev=0)
COMMIT_COUNT_SINCE_TAG=$(git rev-list --count ${LATEST_TAG}..)
if [ $LATEST_TAG = "start" ]; then
    LATEST_TAG=0
fi

if [ $COMMIT_COUNT_SINCE_TAG = 0 ]; then
    SHORT_VERSION="$LATEST_TAG"
else
    # increment final digit of tag and append "d" + commit-count-since-tag
    # e.g. commit after 1.0 is 1.1d1, commit after 1.0.0 is 1.0.1d1
    # this is the bit that requires /bin/bash
    OLD_IFS=$IFS
    IFS="."
    VERSION_PARTS=($LATEST_TAG)
    LAST_PART=$((${#VERSION_PARTS[@]}-1))
    VERSION_PARTS[$LAST_PART]=$((${VERSION_PARTS[${LAST_PART}]}+1))
    SHORT_VERSION="${VERSION_PARTS[*]}+${COMMIT_COUNT_SINCE_TAG}"
    IFS=$OLD_IFS
fi

# Bundle version (commits-on-master[-until-branch "." commits-on-branch])
# Assumes that two release branches will not diverge from the same commit on master.
if [ $(git rev-parse --abbrev-ref HEAD) = "$(git rev-parse --abbrev-ref HEAD)" ]; then
    MASTER_COMMIT_COUNT=$(git rev-list --count HEAD)
    BRANCH_COMMIT_COUNT=0
    BUNDLE_VERSION="$MASTER_COMMIT_COUNT"
else
    MASTER_COMMIT_COUNT=$(git rev-list --count $(git rev-list master.. | tail -n 1)^)
    BRANCH_COMMIT_COUNT=$(git rev-list --count master..)
    if [ $BRANCH_COMMIT_COUNT = 0 ]; then
        BUNDLE_VERSION="$MASTER_COMMIT_COUNT"
    else
        BUNDLE_VERSION="${MASTER_COMMIT_COUNT}.${BRANCH_COMMIT_COUNT}"
    fi
fi

echo defaults write "$INFO_PLIST" CFBundleShortVersionString "$SHORT_VERSION"
echo defaults write "$INFO_PLIST" CFBundleVersion            "$BUNDLE_VERSION"

#    defaults write "$INFO_PLIST" CFBundleBuildVersion       "$BUILD_VERSION"
defaults write "$INFO_PLIST" CFBundleShortVersionString "$SHORT_VERSION"
defaults write "$INFO_PLIST" CFBundleVersion            "$BUNDLE_VERSION"
#defaults write "$INFOPLIST_FILE" CFBundleShortVersionString "$SHORT_VERSION"
#defaults write "$INFOPLIST_FILE" CFBundleVersion            "$BUNDLE_VERSION"

