package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
)

func main() {
	emailAddress := os.Getenv("EMAIL_ADDRESS")
	emailAddressData := []byte(fmt.Sprintf("%s\n", emailAddress))
	err := ioutil.WriteFile("fastlane/metadata/review_information/email_address.txt", emailAddressData, 0777)
	if err != nil {
		log.Fatalln("could not write to email address file")
	}

	phoneNumber := os.Getenv("PHONE_NUMBER")
	phoneNumberData := []byte(fmt.Sprintf("%s\n", phoneNumber))
	err = ioutil.WriteFile("fastlane/metadata/review_information/phone_number.txt", phoneNumberData, 0777)
	if err != nil {
		log.Fatalln("could not write to phone number file")
	}

	deliverFileContent := fmt.Sprintf(`#  Deliverfile
	
username "%s"
force true
automatic_release false
sync_screenshots true`, emailAddress)
	deliverFileContentData := []byte(fmt.Sprintf("%s\n", deliverFileContent))
	err = ioutil.WriteFile("fastlane/Deliverfile", deliverFileContentData, 0777)
	if err != nil {
		log.Fatalln("could not write to phone number file")
	}
}
