#!/usr/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $SCRIPT_DIR/..

bazel query 'deps(//...)' --noimplicit_deps --notool_deps --output=graph | grep -v 'downloaded' >doc/bigpicture.dot
dot -Tsvg doc/bigpicture.dot -o doc/bigpicture.svg
