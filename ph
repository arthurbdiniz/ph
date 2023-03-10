#!/usr/bin/env bash
set -e

start_command() {
    git config --global pager.branch false

    if [ -z "$PATCH_DEFAULT_BRANCH" ]
    then
        export PATCH_DEFAULT_BRANCH="main"
    fi

    default_branch=$((git branch -a --contains tags/upstream 2> /dev/null || echo $PATCH_DEFAULT_BRANCH) | sed -n '1p' | rev | cut -d ' ' -f 1 | rev)

    git checkout $default_branch
    git tag -f -m "upstream" upstream
    git checkout -b patching

    if [ `git rev-parse --verify patches 2>/dev/null` ]
    then
        echo "Getting patches"
        git cherry-pick ..patches
    fi

    git tag -f -m "branch/patches" branch/patches

    if [ -d "./patches" ]
    then
        git apply --stat patches/*
        git am patches/*
    fi
}

pack_command() {
    git config --global pager.branch false

    rm -rf patches
    git format-patch branch/patches..HEAD -o patches
    git reset --hard branch/patches

    git tag -d branch/patches

    if [ `git rev-parse --verify patches 2>/dev/null` ]
    then
        git checkout patches
    else
        git checkout --orphan patches
        git rm -rf . > /dev/null 2>&1
        echo "------------------------------------"
        echo "Your patch branch is ready, now run:"
        echo "------------------------------------"
        echo "git add patches/"
        echo "git commit -m 'Initial patch'"
        echo "git push origin patches"
    fi

    git branch -D patching  > /dev/null 2>&1
}

cli_help() {
    cli_name=${0##*/}
    echo "Patch Helper
Version: 0.1.0
Usage: $cli_name [command] [option]
Commands:
  start     Prepare patching branch applying pre existent patches
  pack      Save created patches to a folder and checkout to patches branch
  --help"
    exit 1
}

case "$1" in
    start|s)
        start_command
    ;;
    pack|p)
        pack_command
    ;;
    *)
        cli_help
    ;;
esac