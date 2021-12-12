# -*- coding: utf-8 -*-

import os
import time
import re
import sys
import os.path
#import property_analyze

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

def analyzeSourceFileContent(content):
    return

def analyzeHeaderFileContent(content):
    analyzeErrorProperty(content)

def codeAnalyze(rootPath):
    for list in os.listdir(rootPath):
        path = os.path.join(rootPath, list)
        if os.path.isdir(path):
            codeAnalyze(path)
        elif path.find('.m') != -1 or path.find('.mm') != -1 :
            f = open(path)
            fileContent = f.read()
            f.close()
            analyzeSourceFileContent(fileContent)
        elif path.find('.h') != -1 :
            f = open(path)
            fileContent = f.read()
            f.close()
            analyzeHeaderFileContent(fileContent)
        else:
            continue

if __name__ == '__main__':
    codeAnalyze("../DebugTools")
