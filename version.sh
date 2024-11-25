#!/usr/bin/env bash
set -e

# Exit script if command fails or uninitialized variables used
set -euo pipefail

VERSION=$(cat VERSION)

# Get version type from first argument passed to script
VERSION_TYPE="${1-}"

VERSION_NEXT=""

case "$VERSION_TYPE" in
  "patch")
      VERSION_NEXT="$(echo "$VERSION" | awk -F. '{$NF++; print $1"."$2"."$NF}')";;
  "minor")
      VERSION_NEXT="$(echo "$VERSION" | awk -F. '{$2++; $3=0; print $1"."$2"."$3}')";;
  "major")
      VERSION_NEXT="$(echo "$VERSION" | awk -F. '{$1++; $2=0; $3=0; print $1"."$2"."$3}')";;
  *)
    printf "\nError: invalid VERSION_TYPE arg passed, must be 'patch', 'minor' or 'major'\n\n"
    exit 1;;
esac

echo "VERSION_NEXT: ${VERSION_NEXT}"

echo $VERSION_NEXT > VERSION
