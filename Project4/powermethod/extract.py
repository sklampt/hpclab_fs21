import re, string
import sys
from pathlib import Path

print('k,n,p,name,value')

for file in sys.argv[1:]:
    path = Path(file)
    f = open(path,"r")
    text = f.read()
    k, n, p = path.stem.split('-')

    patterns = [
        ['ki', 'Ki   = ([\d.e+]+)'],
        ['ni', 'Ni   = ([\d.e+]+)'],
        ['size', 'size = ([\d.e+]+)'],
        ['N', 'N    = ([\d.e+]+)'],
        ['time', 'time = ([\d.e+]+)'],
    ]

    for name, pattern in patterns:
        m = re.search(
            pattern,
            text,
            re.IGNORECASE
        )
        print(k, n, p, name, m.group(1), sep=',')
