#!/usr/bin/python2
"""
*
* *
* * *
* * * *
* * * * *
* * * *
* * *
* *
*
"""

idx = 0

while idx < 5:
    tempIdx = idx
    star = "*"
    while tempIdx > 0:
        star += "*"
        tempIdx -= 1
    print star
    idx += 1

idx = 4

while idx > 0:
    idx -= 1
    tempIdx = idx
    star = "*"
    while tempIdx > 0:
        star += "*"
        tempIdx -= 1
    print star
    
