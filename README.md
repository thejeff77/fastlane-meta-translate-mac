# fastlane Metadata Translate for Mac/iOS

Manage one set of metadata via fastlane, translate the rest

Utilizes the translate cli https://github.com/soimort/translate-shell

## Pre-requisites

- Install brew for mac
- Setup fastlane folder with downloaded metadata. Requires folders for all languages you have in app store connect within the metadata directory. Ex: metadata/es

## Setup

Put translate.sh in your fastlane folder, or add this repo as a submodule

> git submodule add https://github.com/thejeff77/fastlane-meta-translate-mac.git

Install dependent brew packages:

> cd fastlane-meta-translate-mac

> chmod 777 ./translate.sh

> ./translate.sh --setup

or:

> ./translate.sh -s

## Running translations:

> ./translate.sh --searchpath metadata/ --file subtitle.txt --baselang en-US

or the shorter version:

> ./translate.sh -p metadata/ -f subtitle.txt -b en-US

baselang must be an existing folder with metadata. The example command above will use the metadata/en-US/subtitle.txt file as the base for translating subtitle.txt into the other language directories that exist in the fastlane/metadata folder.

Options:

- (-s|--setup) Install required packages for the script to run.
- (-p|--searchpath) The relative path to the fastlane metadata folder to use for translations.
- (-f|--file) The file to translate. Eg: description.text, release_notes.txt
- (-b|--baselang) The base language folder to use as the source of the translation.

NOTES:
- Does not support locale. If you have a zh-Hans folder, the translator will run translation for zh. The reason for this is due to the limited locale support for the translate cli (see documentation here: https://github.com/soimort/translate-shell
