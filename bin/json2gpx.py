#!/usr/bin/env python
"""Convert JSON from Google Takeout to GPX"""
import json
import os
import time
import argparse

def write_gpx(filep, locations):
    """Write locations as GPX to filep."""
    filep.write(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<gpx creator="json2gpx" version="0.1" xmlns="http://www.topografix.com/GPX/1/0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd">\n'
        '<trk><name><![CDATA[Europe]]></name><trkseg>\n')
    for point in locations:
        filep.write('<trkpt lat="{:f}" lon="{:f}">\n'.format(
            float(point['latitudeE7'])/1e7,
            float(point['longitudeE7'])/1e7))
        if 'altitude' in point:
            filep.write('  <ele>{:f}</ele>\n'.format(
                float(point['altitude'])))
        filep.write('  <time>{:s}</time>\n'.format(
            time.strftime('%Y-%m-%dT%H:%M:%SZ',
                          time.gmtime(float(point['timestampMs'])/1000))))
        filep.write('</trkpt>\n')
    filep.write('</trkseg></trk></gpx>\n')

def main():
    """Convert JSON to GPX."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("json", type=str,
                        help="Input JSON file")
    args = parser.parse_args()

    with open(args.json, 'r') as file_:
        locations = json.load(file_)['locations']
    locations.reverse()
    with open(os.path.splitext(args.json)[0] + '.gpx', 'w') as file_:
        write_gpx(file_, locations)

if __name__ == "__main__":
    main()
