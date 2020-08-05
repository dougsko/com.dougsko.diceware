#!/usr/bin/env python3

# uses the version name and code from pubspec.yaml and updates
# AndroidManifest.xml

from xml.dom.minidom import parse

with open("pubspec.yaml") as f:
    for line in f.readlines():
        option = line.split(":")
        # print(option)
        if option[0] == "version":
            version = option[1].split("+")
            versionName = version[0].lstrip()
            versionCode = version[1].rstrip()

dom1 = parse("android/app/src/main/AndroidManifest.xml")
dom1.documentElement.setAttribute("android:versionName", versionName)
dom1.documentElement.setAttribute("android:versionCode", versionCode)
with open("android/app/src/main/AndroidManifest.xml", 'w') as f:
    dom1.writexml(f)
