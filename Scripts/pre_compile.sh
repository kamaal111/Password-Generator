#!/bin/sh

#  pre_compile.sh
#  Password-Generator
#
#  Created by Kamaal M Farah on 06/09/2021.
#  

if which swiftlint >/dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
