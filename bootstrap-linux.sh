#! /usr/bin/env bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Please pass either <latop> or <desktop> (without the angles) as a parameter"
  exit
fi

echo "Installing i3 and related tools"
installi3.sh $1

echo "Setting up ui customisations for i3"
customisei3.sh $1

echo "Setting up dev tools"
setup-devenv.sh $1

