import os
import sys
import glob
from mutagen.easyid3 import EasyID3
import urllib
from lxml import html, etree
from subprocess import call
import mutagen
import traceback
import httplib2
import argparse

def main():

    parser = argparse.ArgumentParser(description="Organise music folders in <artist> - <album> [<tags>...] looking for tags at LastFM.")
    parser.add_argument("sourcedir", help="source dir where the music folders to modify are present") 
    parser.add_argument("targetdir", help="target dir where to place the converted music directories") 
    args = parser.parse_args()

    subdirs = [x[0] for x in os.walk(args.sourcedir) if x[0] != "Cover"]

    ok_entries = []
    failed_files = []

    bad_tags = [ "metal", "electronic", "electronica" ]
    for folder in subdirs:
        files = [f for f in os.listdir(folder) if f.endswith("mp3") ]
        isleaf = 1
        for f in os.listdir(folder):
            if os.path.isdir(f):
                isleaf = 0
        if isleaf == 1 and len(files) > 0:
            mp3file = files[0]
            artist = ""
            try:
                mp3info = EasyID3(folder + "/" + mp3file)
                artist = mp3info["artist"][0]
                album = mp3info["album"][0]

                # extract tags from lastfm
                tags = []
                url="http://www.last.fm/es/music/" + artist.replace(" ", "+")
                page = html.fromstring(urllib.urlopen(httplib2.iri2uri(url)).read())
                for element in page.xpath("//li[@class='tag']/a"):
                    tags.append(element.text)
                tags = filter((lambda x: x not in bad_tags), tags)
                if len(tags) == 0:
                    raise Exception("no tags")
                else:
                    print(tags)

                ok_entries.append([folder, artist, album, mp3file, tags])
                new_folder_name = args.targetdir + artist + " - " + album
                for tag in tags:
                    new_folder_name += " [" + tag + "]"
                call(["mv", folder, new_folder_name])

            except (Exception, mutagen._id3util.ID3NoHeaderError) as e:
                print(e)
                traceback.print_exc()
                failed_files.append([folder, mp3file])


if __name__ == '__main__':
    main()

