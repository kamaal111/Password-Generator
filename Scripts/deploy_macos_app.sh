#!/bin/sh

#  deploy_macos_app.sh
#  Password-Generator
#
#  Created by Kamaal M Farah on 13/10/2021.
#  

PRODUCT_NAME="Passlify"
ENTITLEMENTS_FILE_PATH="Targets/macOS/macOS.entitlements"
DISTRIBUTION_CERTIFICATE_NAME="Apple Distribution: Kamaal Farah (DXUKH9VF73)"
THIRD_PARTY_MAC_INSTALLER_NAME="3rd Party Mac Developer Installer: Kamaal Farah (DXUKH9VF73)"
SCHEME="Password-Generator (macOS)"

# TODO: Get real source
PROVISIONING_PROFILE_DATA=""

set -o pipefail && xcodebuild -scheme "$SCHEME" -project Password-Generator.xcodeproj \
    -configuration Release -destination generic/platform=macOS \
    -archivePath "$PRODUCT_NAME".xcarchive clean archive | bundle exec xcpretty || exit 1

APP_PATH="$PRODUCT_NAME.xcarchive/Products/Applications/$PRODUCT_NAME.app"

plutil -convert xml1 "$ENTITLEMENTS_FILE_PATH"

codesign -d --entitlements "$ENTITLEMENTS_FILE_PATH" "$APP_PATH"
echo "$PROVISIONING_PROFILE_DATA" | base64 --decode > "$APP_PATH"/Contents/embedded.provisionprofile

codesign -f -s "$DISTRIBUTION_CERTIFICATE_NAME" -i io.kamaal.Password-Generator --entitlements "$ENTITLEMENTS_FILE_PATH" -vv "$APP_PATH"

xcrun productbuild --component "$APP_PATH" /Applications/ "$PRODUCT_NAME".unsigned.pkg

xcrun productsign --sign "$THIRD_PARTY_MAC_INSTALLER_NAME" "$PRODUCT_NAME".unsigned.pkg "$PRODUCT_NAME".pkg

xcrun altool --upload-app -t osx -f "$PRODUCT_NAME".pkg -u "$APP_STORE_CONNECT_USERNAME" -p "$APP_STORE_CONNECT_PASSWORD"