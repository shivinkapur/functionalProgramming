
# Name: Shivin Kapur
#
# UID: 404259526
#
# People I interacted with:
#
# Resources I used: https://docs.python.org/2/tutorial/
#

import struct
import math

# PROBLEM 1

# parse the file named fname into a dictionary of the form
# {'width': int, 'height' : int, 'max' : int, 'pixels' : (int * int * int) list}
def parsePPM(fname):

    ppmImage = open(fname, mode ='rb')
    rP6 = ppmImage.readline()
    [width, height] = (ppmImage.readline()).split()
    [maxPPM] = (ppmImage.readline()).split()
    pixelsData = ppmImage.read()
    ppmImage.close()

    ppm = {}
    ppm['width'] = int(width)
    ppm['height'] = int(height)
    ppm['max'] = int(maxPPM)

    pixels = []
    for R, G, B in (pixelsData[i:i+3] for i in xrange(0, len(pixelsData), 3)):
        pixels.append(struct.unpack('BBB', R+G+B))
    ppm['pixels'] = pixels
    ppmImage.close()
    return ppm

# a test to make sure you have the right format for your dictionaries
def testParsePPM():
    return parsePPM("example.ppm") == {'width': 2, 'max': 255, 'pixels': [(10, 23, 52), (82, 3, 215), (30, 181, 101), (33, 45, 205), (40, 68, 92), (111, 76, 1)], 'height': 3}

# write the given ppm dictionary as a PPM image file named fname
# the function should not return anything
def unparsePPM(ppm, fname):
    ppmImage = open(fname, mode = 'wb')
    ppmImage.write("P6\n" + str(ppm['width']) + " " + str(ppm['height']) + "\n")
    ppmImage.write(str(ppm['max']) + "\n")
    unparsePixels = [struct.pack('BBB', p[0], p[1], p[2]) for p in ppm['pixels']]
    ppmImage.writelines(unparsePixels)
    ppmImage.close()


# PROBLEM 2
def negate(ppm):
    pixelsNegate = []
    ppmNegate = {}
    for (R,G,B) in ppm['pixels']:
        R = ppm['max'] - R
        G = ppm['max'] - G
        B = ppm['max'] - B
        pixelsNegate.append((R,G,B))
    ppmNegate['width'] = ppm['width']
    ppmNegate['height'] = ppm['height']
    ppmNegate['max'] = ppm['max']
    ppmNegate['pixels'] = pixelsNegate
    return ppmNegate


# PROBLEM 3
def mirrorImage(ppm):
    pixelsMirror = []
    ppmMirror = {}
    count = 0
    pixelRows = []
    for (R,G,B) in ppm['pixels']:
        pixelRows.insert(0,(R, G, B))
        count += 1
        if count == ppm['width']:
            pixelsMirror.extend(pixelRows)
            pixelRows = []
            count = 0
    ppmMirror['width'] = ppm['width']
    ppmMirror['height'] = ppm['height']
    ppmMirror['max'] = ppm['max']
    ppmMirror['pixels'] = pixelsMirror
    return ppmMirror


# PROBLEM 4

# produce a greyscale version of the given ppm dictionary.
# the resulting dictionary should have the same format,
# except it will only have a single value for each pixel,
# rather than an RGB triple.
def greyscale(ppm):
    pixelsGrayscale = []
    ppmGrayscale = {}
    for (R, G, B) in ppm['pixels']:
        res = round(.299*R + .587*G + .114*B)
        pixelsGrayscale.append(res)
    ppmGrayscale['width'] = ppm['width']
    ppmGrayscale['height'] = ppm['height']
    ppmGrayscale['max'] = ppm['max']
    ppmGrayscale['pixels'] = pixelsGrayscale
    return ppmGrayscale

# take a dictionary produced by the greyscale function and write it as a PGM image file named fname
# the function should not return anything
def unparsePGM(pgm, fname):
    ppmImage = open(fname, mode = "wb")
    ppmImage.write("P5\n")
    ppmImage.write(str(pgm['width']) + " ")
    ppmImage.write(str(pgm['height']) + "\n")
    ppmImage.write(str(pgm['max']) + "\n")
    unparsePixels = [struct.pack('B', p) for p in pgm['pixels']]
    ppmImage.writelines(unparsePixels)
    ppmImage.close()


# PROBLEM 5

# gaussian blur code adapted from:
# http://stackoverflow.com/questions/8204645/implementing-gaussian-blur-how-to-calculate-convolution-matrix-kernel
def gaussian(x, mu, sigma):
  return math.exp( -(((x-mu)/(sigma))**2)/2.0 )

def gaussianFilter(radius, sigma):
    # compute the actual kernel elements
    hkernel = [gaussian(x, radius, sigma) for x in range(2*radius+1)]
    vkernel = [x for x in hkernel]
    kernel2d = [[xh*xv for xh in hkernel] for xv in vkernel]

    # normalize the kernel elements
    kernelsum = sum([sum(row) for row in kernel2d])
    kernel2d = [[x/kernelsum for x in row] for row in kernel2d]
    return kernel2d

# blur a given ppm dictionary, returning a new dictionary
# the blurring uses a gaussian filter produced by the above function
def gaussianBlur(ppm, radius, sigma):
    # obtain the filter
    gfilter = gaussianFilter(radius, sigma)
    width = ppm['width']
    height = ppm['height']
    pixelsGaussian = ppm['pixels']
    R_blur = 0.0
    B_blur = 0.0
    G_blur = 0.0
    pixels_blur_all = list(pixelsGaussian)
    for i in range(radius, height-radius):
        for j in range(radius, width-radius):
            R_blur = 0.0
            B_blur = 0.0
            G_blur = 0.0
            for x in range(-radius, radius+1):
                for y in range(-radius, radius+1):
                    R_blur += gfilter[x+radius][y+radius] * pixelsGaussian[(i+x)*width+j+y][0]
                    B_blur += gfilter[x+radius][y+radius] * pixelsGaussian[(i+x)*width+j+y][1]
                    G_blur += gfilter[x+radius][y+radius] * pixelsGaussian[(i+x)*width+j+y][2]
            pixels_blur_all[i*width+j] = (int(round(R_blur)), int(round(B_blur)), int(round(G_blur)))
    ppmGaussian = {}
    ppmGaussian['width'] = ppm['width']
    ppmGaussian['height'] = ppm['height']
    ppmGaussian['max'] = ppm['max']
    ppmGaussian['pixels'] = pixels_blur_all
    return ppmGaussian
