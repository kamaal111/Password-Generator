#!/bin/sh

#  run_tests.sh
#  Password-Generator
#
#  Created by Kamaal Farah on 05/10/2021.
#  

PROJECT="Password-Generator.xcodeproj"

iOS_destinations=(
  "platform=iOS Simulator,name=iPhone 13 Pro Max"
)

iOS_test_schemes=(
  "Password-Generator (iOS)"
)

xcode_test() {
    set -o pipefail && xcodebuild test -project "$PROJECT" -scheme "$1" -destination "$2" | bundle exec xcpretty || exit 1
}

test_all_destinations() {
  time {
      for destination in "${iOS_destinations[@]}"
      do 
        for scheme in "${iOS_test_schemes[@]}"
        do 
        xcode_test "$scheme" "$destination"
        done
    done
  }
}

test_all_destinations