#!/bin/python

import errno
import os
import re

# 1. Change working directory to httpd
os.chdir('/etc/httpd/')

# 2. Check and create directories.
if not os.path.exists('mods-available/'):
	os.makedirs('mods-available/')

if not os.path.exists('mods-enabled/'):
	os.makedirs('mods-enabled/')

# 3. Open file
try:
	conf = open('conf.modules.d/00-base.conf')
except (IOError, OSError) as e:
	if e.errno == errno.ENOENT:
		print "File already gone."
		quit()

# 4. for each line in the file
for line in conf:

	# 5. Look for the LoadModule directive with parameters.
	match = re.search('LoadModule (\S+) modules/(\S+)', line)
	if match is None:
		continue

	# 6. Get the modulename, and strip mod_ or _module form it.
	filename = match.group(1)
	filename = filename.replace('mod_','')
	filename = filename.replace('_module','')

	# 7. Write the LoadModule statement to a single separate file.
	out = open('mods-available/' + filename + '.load', "w")
	out.write("LoadModule %s /usr/lib64/httpd/modules/%s\n" % (match.group(1), match.group(2)))

	# 8. If it's commented out, try to remove a file/symlink in mods-enabled/.
	# then start at the top, do a new line
	if  line[0] == '#':
		try:
			os.remove('mods-enabled/' + filename + '.load')
		except OSError as e:
			if e.errno != errno.ENOENT:
				raise
		continue

	# 9. If it's not commented out, it's enabled. Try creating a symlink in mods-enabled/
	# if there's already a file. Remove it and create a new one.
	try:
		os.symlink('../mods-available/' + filename + '.load', 'mods-enabled/' + filename + '.load')
	except OSError as e:
		if e.errno == errno.EEXIST:
			os.remove('mods-enabled/' + filename + '.load')
			os.symlink('../mods-available/' + filename + '.load', 'mods-enabled/' + filename + '.load')

# 10. Close file, just for tidyness sake.
conf.close()

# 11. Remove this file.
try:
	os.remove('conf.modules.d/00-base.conf')
except OSError as e:
	if e.errno != errno.ENOENT:
		raise

