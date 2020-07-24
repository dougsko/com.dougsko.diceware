#!/usr/bin/env python3

import os

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



