#!/user/bin/env python3

import sys
import argparse
import pysam

parser = argparse.ArgumentParser()
parser.add_argument("-n",type=str)
parser.add_argument("-c",type=str)
args = parser.parse_args()


