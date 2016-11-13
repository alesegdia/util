# Generates OpenGL function names from a file

import sys
import re

infile = open( sys.argv[1], 'r' )

ret = "  return\n"

for line in infile.readlines():
	try:
		funcname = line.rstrip()
		print "  PFN" + funcname.upper() + "PROC " + funcname[2:] + ";"
		ret += "    GetProc( &" + funcname[2:] + ", \"" + funcname + "\" ) &&\n"

	except IndexError:
		print '';
	#( functype, funcname ) = p[0].split()

print ''

print ret[:-4] + ";"
