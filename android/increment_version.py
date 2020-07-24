#!/usr/bin/env python3

import os
from xml.dom.minidom import parse

with open("local.properties.new", 'w') as newf:
    with open("local.properties") as f:
        for line in f:
            key = line.split("=")[0]
            value = line.split("=")[1].rstrip()
            if key == "flutter.versionCode":
                value = str(int(value) + 1)

            if key == "flutter.versionName":
                value = str(value.split('.')[0]) + '.' + str(value.split('.')[1]) + '.' + str(int(value.split('.')[-1]) + 1)

            newf.write('%s=%s\n' % (key, value))

os.rename('local.properties.new', 'local.properties')

dom1 = parse("app/src/main/AndroidManifest.xml")
oldVersion = dom1.documentElement.getAttribute("android:versionName")
oldVersionCode = dom1.documentElement.getAttribute("android:versionCode")
versionNumbers = oldVersion.split('.')

versionNumbers[-1] = str(int(versionNumbers[-1]) + 1)
dom1.documentElement.setAttribute("android:versionName", u'.'.join(versionNumbers))
dom1.documentElement.setAttribute("android:versionCode", str(int(oldVersionCode)+1))
with open("app/src/main/AndroidManifest.xml", 'w') as f:
    for line in dom1.toxml("utf-8"):
        f.write(str(line))



