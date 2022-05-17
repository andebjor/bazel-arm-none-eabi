#!/bin/bash
set -euo pipefail

runfiles=${BASH_SOURCE[0]}.runfiles
tool=$(sed -n '3p' < "${runfiles}/MANIFEST" | cut -d ' ' -f 2)

footer="${0#*execroot/*/}"
execroot=${0%$footer}
echo "cd ${execroot}"
cd ${execroot}

$tool "$@"
