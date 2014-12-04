#!/bin/bash

cd $(dirname $0)

key=0
unkey=0
if [ "$1"x == "-key"x -o "$1"x == "--key"x ]; then
  key=1
elif [ "$1"x == "-unkey"x -o "$1"x == "--unkey"x ]; then
  unkey=1
fi

if [ ! -e GoogleMaps.framework ] || [ $key -eq 1 ]; then
  GMAPS_DIST_ZIP=GoogleMaps-iOS-1.9.0.zip
  if [ -r ${GMAPS_DIST_ZIP} ]; then
    GMAPS_DIST_PATH=""
  elif [ -r "../${GMAPS_DIST_ZIP}" ]; then
    GMAPS_DIST_PATH="../"
  elif [ -r "${HOME}/Desktop/${GMAPS_DIST_ZIP}" ]; then
    GMAPS_DIST_PATH="$HOME/Desktop/"
  elif [ -r "${HOME}/${GMAPS_DIST_ZIP}" ]; then
    GMAPS_DIST_PATH="$HOME/"
  fi
fi

if [ ! -e GoogleMaps.framework ]; then
  if [ ! -r "${GMAPS_DIST_PATH}${GMAPS_DIST_ZIP}" ]; then
    (cd ..; curl -O "https://dl.google.com/geosdk/GoogleMaps-iOS-1.9.0.zip")
    GMAPS_DIST_PATH="../"
  fi
  unzip "${GMAPS_DIST_PATH}${GMAPS_DIST_ZIP}" GoogleMaps-iOS-1.9.0/GoogleMaps.framework/\*
  mv GoogleMaps-iOS-1.9.0/GoogleMaps.framework .
  rmdir GoogleMaps-iOS-1.9.0

  key=1
fi

if [ $key -eq 1 ]; then
  GMAPS_API_KEY_FILE=GoogleMaps-API-Key.txt
  API_KEY=$(cat ${GMAPS_DIST_PATH}${GMAPS_API_KEY_FILE})
  if [ -e ${GMAPS_DIST_PATH}${GMAPS_API_KEY_FILE} ]; then
    API_KEY=$(cat ${GMAPS_DIST_PATH}${GMAPS_API_KEY_FILE})
  fi
  while [ "${API_KEY}"x == ""x ]; do
    API_KEY=$(osascript -e 'Tell application "System Events" to display dialog "Please select and then Copy the Google Maps API key and then hit Okay" buttons {"Okay"}' -e 'get the clipboard' 2>/dev/null)
    if [ $? -ne 0 ]; then exit -1; fi
    if echo ${API_KEY}|grep "^AIza">/dev/null && [ $(echo ${API_KEY}|wc -c|awk '{ print $1 }') -gt 30 ]; then
      true
    else
      osascript -e 'Tell application "System Events" to display dialog "No, really, this won'\''t work if you don'\''t give me the key..." buttons {"Okay","Cancel"}' >/dev/null 2>&1
      if [ $? -ne 0 ]; then exit -1; fi
      API_KEY=
    fi
  done
  if [ ! -e ${GMAPS_DIST_PATH}${GMAPS_API_KEY_FILE} ]; then
    echo $API_KEY > ${GMAPS_DIST_PATH}${GMAPS_API_KEY_FILE}
  fi
  sed -i "" -e "s|GOOGLE_MAPS_API_KEY|${API_KEY}|g" BarreForestGuide/AppDelegate.m
elif [ $unkey -eq 1 ]; then
  sed -i "" -e 's|\(provideAPIKey:@"\)[^"]*"|\1GOOGLE_MAPS_API_KEY"|g' BarreForestGuide/AppDelegate.m
fi

exit 0
