#!/bin/bash

# shellcheck disable=SC1090

# Execute modules in order
working_directory=$(dirname "${BASH_SOURCE[0]}")
modules=$(find "$working_directory/modules" -maxdepth 1 -name '*.sh' | sort | sed -r 's/\.\///g')

for module in $modules; do
  source "$module"
done
