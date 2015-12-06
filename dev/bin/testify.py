#!/usr/bin/env python
#
# testify.py - creates a test from examples
#

import re
import argparse

parser = argparse.ArgumentParser()
parser.add_argument( '--sv', help = 'input sv file', required = True )
args = parser.parse_args()
code = re.compile( r'^\s*//\s\|\s*(?P<code>.*)$' )
indent = '    '

f = open( args.sv )
print indent + '// test ' + args.sv
in_code = False
for line in f:
    m = code.match( line )
    if m:
        if not in_code:
            print indent + 'begin'
        in_code = True
        print indent + '  ' + m.group( 'code' )
    elif in_code:
        print indent + 'end'
        in_code = False
        
