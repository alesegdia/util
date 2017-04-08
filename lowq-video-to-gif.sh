
ffmpeg -i ffb.mp4 -vf scale=320:-1 -r 5 -f image2pipe -vcodec ppm - |   convert -delay 10 -loop 0 - output.gif
