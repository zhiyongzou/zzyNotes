# -*- coding: utf-8 -*-

import os
import time
import re
import sys
import os.path

def analyzeErrorProperty(content):
    # @property (nonatomic, assign) NSObject *obj;
    AssignObject = re.search(r'@property{1,1}\s*\(.*assign.*\).*\*.*;', content)
    if AssignObject :
        print AssignObject.group()
    
    # @property (nonatomic, copy) NSMutableArray *array;
    MutableCopy = re.search(r'@property{1,1}\s*\(.*copy.*\).*NSMutable{1,1}.*\*.*;', content)
    if MutableCopy :
        print MutableCopy.group()
    
    # @property (nonatomic, strong) id<NSCopying> delegate;
    delageteStrong = re.search(r'@property{1,1}\s*\(.*strong.*\)\s*id\s*<.*>.*delegate;', content)
    if delageteStrong :
        print delageteStrong.group()
    
    # @property (nonatomic, assign) id obj;
    idAssign = re.search(r'@property{1,1}\s*\(.*assign.*\)\s*id((<{1,1})|(\s*)).*;', content)
    if idAssign :
        idAssign.group()

