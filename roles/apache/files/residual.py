#!/usr/bin/python

from __future__ import print_function

import os
import re

os.chdir("/etc/httpd/")

mods = os.listdir("mods-available")

for mod in mods:
	conf = open("mods-available/" + mod, "r")
	for line in conf:
		match = re.search("LoadModule (\S+) modules/(\S+)", line)
		if match is None:
			continue

		conf.close()

		print("Fixing mods-available/%s\n" % mod)
		conf = open("mods-available/" + mod, "w")
		conf.write("LoadModule %s /usr/lib64/httpd/modules/%s\n" % (match.group(1), match.group(2)))
		conf.close()
		break

os.remove("conf.d/README")

if os.listdir("conf") == []:
	os.rmdir("conf")	

if os.listdir("conf.d") == []:
	os.rmdir("conf.d")

if os.listdir("conf.modules.d") == []:
	os.rmdir("conf.modules.d")

os.remove("logs")
os.remove("modules")
os.remove("run")

