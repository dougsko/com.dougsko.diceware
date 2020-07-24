#!/usr/bin/python
from xml.dom.minidom import parse

dom1 = parse("AndroidManifest.xml")
oldVersion = dom1.documentElement.getAttribute("android:versionName")
oldVersionCode = dom1.documentElement.getAttribute("android:versionCode")
versionNumbers = oldVersion.split('.')

versionNumbers[-1] = str(int(versionNumbers[-1]) + 1)
dom1.documentElement.setAttribute("android:versionName", u'.'.join(versionNumbers))
dom1.documentElement.setAttribute("android:versionCode", str(int(oldVersionCode)+1))
with open("AndroidManifest.xml", 'w') as f:
    for line in dom1.toxml("utf-8"):
        f.write(line)