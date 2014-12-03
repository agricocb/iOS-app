#!/bin/bash

if [ ! -e FacebookSDK ]; then
  FACEBOOK_DIST_ZIP=facebook-ios-sdk-3.21.pkg
  if [ -r ${FACEBOOK_DIST_ZIP} ]; then
    FACEBOOK_DIST_PATH=""
  elif [ -r "../${FACEBOOK_DIST_ZIP}" ]; then
    FACEBOOK_DIST_PATH="../"
  elif [ -r "${HOME}/Desktop/${FACEBOOK_DIST_ZIP}" ]; then
    FACEBOOK_DIST_PATH="$HOME/Desktop/"
  elif [ -r "${HOME}/${FACEBOOK_DIST_ZIP}" ]; then
    FACEBOOK_DIST_PATH="$HOME/"
  fi
fi

if [ ! -e FacebookSDK ]; then
  if [ ! -r "${FACEBOOK_DIST_PATH}${FACEBOOK_DIST_ZIP}" ]; then
    (cd ..; curl -O "https://developers.facebook.com/resources/facebook-ios-sdk-3.21.pkg")
    FACEBOOK_DIST_PATH="../"
  fi

  mkdir .tmp
  xar -C .tmp -xf "${FACEBOOK_DIST_PATH}${FACEBOOK_DIST_ZIP}" FacebookSDK.pkg/Payload
  tar -C .tmp -xzf .tmp/FacebookSDK.pkg/Payload Documents/FacebookSDK
  mv .tmp/Documents/FacebookSDK .
  rm -r .tmp

fi

exit 0
