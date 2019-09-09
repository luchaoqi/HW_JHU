import sys

from load import load
from generate import generate

# Script to run the program as needed

n = 1 #	Default number of sent is 1
tree = False # Default for tree option is false

if(len(sys.argv) == 1 ):
	print "Please provide a valid grammar file for generating sentences."
if(len(sys.argv) == 2 ):
	filename = sys.argv[1]
if(len(sys.argv) == 3 ):
	filename = sys.argv[1]
	n = int(sys.argv[2])
if(len(sys.argv) == 4 ):
	if(sys.argv[1] == '-t'):
		tree = True
	filename = sys.argv[2]
	n = int(sys.argv[3])


rules = load(filename)
for i in xrange(n):
	print generate(rules, tree)

