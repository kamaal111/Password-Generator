#!/bin/bash

#  import_signing_certificate_macos.bash
#  Password-Generator
#
#  Created by Kamaal M Farah on 05/10/2021.
#  

set -euo pipefail

security create-keychain -p "$KEYCHAIN_PASSPHRASE" build.keychain
security list-keychains -s build.keychain
security default-keychain -s build.keychain
security unlock-keychain -p "$KEYCHAIN_PASSPHRASE" build.keychain
security set-keychain-settings

security import <(echo $SIGNING_CERTIFICATE_P12_DATA | base64 --decode) \
                -f pkcs12 \
                -k build.keychain \
                -P $SIGNING_CERTIFICATE_PASSWORD \
                -T /usr/bin/codesign
security import <(echo $THIRD_PARTY_MAC_INSTALLER_CERTIFICATE | base64 --decode) \
                -f pkcs12 \
                -k build.keychain \
                -P $THIRD_PARTY_MAC_INSTALLER_PASSWORD \
                -T /usr/bin/productsign

security set-key-partition-list -S apple-tool:,apple: -s -k "$KEYCHAIN_PASSPHRASE" build.keychain
