import urllib2
import json
import sys

def addr_to_url(addr):
    return "http://nominatim.openstreetmap.org/?format=json&addressdetails=1&q=" + addr.strip().replace(" ", "+") + "&format=json&limit=1"

def addr_to_geo(addr):
    url = addr_to_url(addr)
    jsonreq = urllib2.urlopen(url).read()
    data = json.loads(jsonreq)
    return { key : data[0][key] for key in { "lat", "lon" } }

if len(sys.argv) != 2:
    print 'Usage: python addr2geo "<address>"'
else:
    print addr_to_geo(sys.argv[1])
