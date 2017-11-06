#! /usr/bin/env python

###############################################################
# In your .bashrc/.zshrc add `eval $(python <path to script>)`
# Or simply run `eval $(python <path to script>)`
# This avoids adding your aws credentials to bash/zsh history
###############################################################

import os, sys
from configparser import ConfigParser
from subprocess import call

def setAwsCredentials(args):
    config = ConfigParser()
    if len(args) > 1:
        config.read(args[1])
    else:
        config.read(os.getenv("HOME") + "/.aws/credentials")

    access = config.get('default', 'aws_access_key_id')
    secret = config.get('default', 'aws_secret_access_key')

    print(f"set -x AWS_ACCESS_KEY_ID {access}; set -x AWS_SECRET_ACCESS_KEY {secret}")

if __name__ == "__main__":
    try:
        setAwsCredentials(sys.argv)
    except:
        pass
