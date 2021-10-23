# Makefile

generate_locales:
	sh Scripts/generate_locales/run.sh

download_store_metadata:
	sh Scripts/download_metadata.sh

download_storescreenshots:
	sh Scripts/download_screenshots.sh

run_tests:
	sh Scripts/run_tests.sh

generate_snapshots:
	sh Scripts/snapshots_ios.sh

upload_metadata_to_store:
	bundle exec fastlane deliver

build_ios:
	bundle exec fastlane gym --scheme "Password-Generator (iOS)"
