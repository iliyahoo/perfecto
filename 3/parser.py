#!/usr/bin/env python


from BeautifulSoup import BeautifulSoup
import urllib2
import json
import sys
from json2html import *


def url_parse(url):
    # sys.setdefaultencoding() does not exist, here!
    reload(sys)  # Reload does the trick!
    sys.setdefaultencoding('UTF8')

    # grab the page
    url = urllib2.urlopen(url)
    content = url.read()
    soup = BeautifulSoup(content)

    # convert to dictionary
    a = json.loads(soup.text)

    # parse
    parsed_dict = {}
    for e in a['records']:
        parsed_dict.setdefault(e['Country'], []).append(e['Name'])

    # convert dict to json
    parsed_json = json.dumps(parsed_dict, ensure_ascii=False, indent=4, sort_keys=True)
    return(parsed_json)


if __name__ == '__main__':
    url = "https://www.w3schools.com/angular/customers.php"
    my_json = url_parse(url)
    infoFromJson = json.loads(my_json)
    print(my_json)
    print("#" * 40)
    print json2html.convert(json = infoFromJson)
