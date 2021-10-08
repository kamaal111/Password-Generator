#!/bin/sh

#  import_provisioning_profile.sh
#  Password-Generator
#
#  Created by Kamaal M Farah on 05/10/2021.
#  

set -euo pipefail

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
echo "$PROVISIONING_PROFILE_MAC_DATA" | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/profile.mobileprovision
