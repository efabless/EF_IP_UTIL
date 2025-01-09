#!/bin/bash
# More safety, by turning some bugs into errors.
set -o errexit -o pipefail -o nounset

# now enjoy the options in order and nicely split until we see --
# option --output/-o requires 1 argument
LONGOPTS=version:
OPTIONS=

# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out "--options")
# -pass arguments only via   -- "$@"   to separate them correctly
# -if getopt fails, it complains itself to stdout
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@") || exit 2
# read getopt's output this way to handle the quoting right:
eval set -- "$PARSED"
unset PARSED


while true; do
    case "$1" in
        --version)
            version="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

echo "+ version=$version"

# zip needed files
tar czf v$version.tar.gz hdl/ef_util_lib.v fw

shasum -a 256 v$version.tar.gz > v$version.tar.gz.sha256

# create tag