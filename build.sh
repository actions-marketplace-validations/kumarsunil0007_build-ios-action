#!/bin/bash -e
if ! type fastlane > /dev/null 2>&1; then
  if type brew > /dev/null 2>&1; then
    brew install fastlane
  else
    sudo gem install fastlane -NV
  fi
fi

script_path=$(cd $(dirname ${0}); pwd)
cp -r ${script_path}/fastlane ./
cp -r ${script_path}/Gemfile ./

echo $P12_BASE64 | base64 --decode > ios-build.p12
echo $MOBILEPROVISION_BASE64 | base64 --decode > ios-build.mobileprovision

if [[ $EXTRA_PROVISIONING = true ]]; then
   echo $MOBILEPROVISION_BASE64_EXTRA | base64 --decode > ios-build-extension.mobileprovision
fi

if [[ $BUILD_PODS = true ]]; then
    bundle install
fi

fastlane export_ipa