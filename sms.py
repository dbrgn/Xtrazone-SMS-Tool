#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys
import json
import pycurl
import urllib

imageviewer = 'eog'
username = 'user'
password = 'pass'

class Curldata:
    def __init__(self):
        self.data = ''
    
    def add(self, buf):
        self.data = self.data + buf
    
    def flush(self):
        self.data = ''

def main():
    # Initialize pycurl and data class
    c = pycurl.Curl()
    c.setopt(c.SSL_VERIFYPEER, 0) # Disable SSL cert verification (fix later)
    d = Curldata()

    # Get CAPTCHA URL
    try:
        c.setopt(c.URL, 'https://xtrazone.sso.bluewin.ch/index.php/20,53,ajax,,,283/?route=%2Flogin%2Fgetcaptcha')
        c.setopt(c.POST, 1) # Enable POST data
        c.setopt(c.POSTFIELDS, 'action=getCaptcha') # POST data
        c.setopt(c.WRITEFUNCTION, d.add) # Define function to process data
        c.perform() # Perform POST request

        resp = json.loads(d.data) # Convert response to dictionary
        captcha_url = 'http:' + resp['content']['messages']['operation']['imgUrl']
        captcha_token = resp['content']['messages']['operation']['token']
    except pycurl.error as e:
        print 'Error: Could not retrieve CAPTCHA'
        return 1

    # Display CAPTCHA using image viewer of choice
    print 'Image viewer has been launched to display CAPTCHA.'
    os.system('%s %s > /dev/null 2>&1 &' % (imageviewer, captcha_url))
    captcha = raw_input('Please enter CAPTCHA: ')
    if captcha == '':
        print 'Error: CAPTCHA may not be empty.'
        return 1

    # Log in
    try:
        d.flush() # Flush previous data
        c.setopt(c.URL, 'https://xtrazone.sso.bluewin.ch/index.php/22,39,ajax_json,,,157/')
        postfields = urllib.urlencode([
                ('action', 'ssoLogin'),
                ('sso_do_login', 1),
                ('passphrase', captcha),
                ('sso_password', password),
                ('sso_user', username),
                ('token', captcha_token),
                ])
        c.setopt(c.POSTFIELDS, postfields)
        c.perform()
        print d.data
    except pycurl.error as e:
        print 'Error: Could not log in'
        return 1

if __name__ == '__main__':
    sys.exit(main())
