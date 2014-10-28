# -*- coding: utf-8 -*-

from pylab import *
from scipy.ndimage import measurements,filters

ion()
gray()

def crop(c,threshold=0.6,r=5):
    b = filters.maximum_filter(c<threshold,r)
    sl = measurements.find_objects(b)[0]
    return c[sl]

def rescale(c):
    return (c-amin(c))/(amax(c)-amin(c))

def charread(fname="c.png"):
    image = mean(imread(fname),axis=2)
    rows = array(linspace(0,image.shape[0],31),'i')
    cols = array(linspace(0,image.shape[1],27),'i')
    chars = [[] for i in range(26)]
    for i in range(26):
        for j in range(30):
            chars[i].append(image[rows[j]:rows[j+1],cols[i]:cols[i+1]])
    chars = [[crop(c) for c in l] for l in chars]
    chars = [[1-rescale(c) for c in l] for l in chars]
    return chars

if __name__=="__main__":
    chars = charread()
    for i in range(25):
        subplot(5,5,i+1)
        imshow(chars[i][i])
    ginput(1,1000)
