# Proof of Concept in Python

import sys

try:
    print(*sys.argv[1:], sep = '\n')
except:
    exit(1)
else:
    exit(0)
