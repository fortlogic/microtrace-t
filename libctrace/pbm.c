/// Functions for PBM files ///

#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "pbm.h"

// This is just for convenience and clarity. You don't have to use it.
ppm_t ppm_createPPM(float *r, float *g, float *b, unsigned w, unsigned h, uint16_t maxval) {
  ppm_t p = { r, g, b, w, h, maxval };
  return p;
}

uint16_t ppm_floatToPixel(float f, uint16_t maxval) {
  return (uint16_t)(f < 0.0f ? 0.0f : (f > 1.0f ? 1.0f*maxval : f*maxval));
}

void ppm_splitShort(unsigned char* dest, uint16_t s) {
  unsigned char upper, lower;
  lower = s & 0xFF;
  upper = (s >> 8) & 0xFF;
  dest[0] = upper;
  dest[1] = lower;
}

int ppm_exportFile(ppm_t p, const char* filename) {

  /* The ppm header requires width and height to be in decimal/ascii,
   * ergo we need to know the number of digits (decimal places) they'll take up.
   * Rather than assume nobody wants an image that goes above some arbirary
   * range of decimal places we deem to be 'enough' we'll do it the proper way.
   * Yay! */
  unsigned widthDigits  = 1 + (unsigned)log10((double)(p.w));
  unsigned heightDigits = 1 + (unsigned)log10((double)(p.h));

  // same thing for the maxval
  unsigned maxvalDigits = 1 + (unsigned)log10((double)(p.maxval));

  //also get the number of bytes maxval will take (either one or two)
  unsigned maxvalBytes = p.maxval > 255 ? 2 : 1;

  // strlen here will give us the size of a string NOT INCLUDING the null terminator.
  // this is the ppm header minus the width, height, and maxval fields
  unsigned headerTemplateSize = strlen("P6    ");

  // add that to the number of digits. This will be the total size of the header
  unsigned headerTotalSize = headerTemplateSize + widthDigits + heightDigits + maxvalDigits;

  const char* headerString        = "P6 %u %u %u ";  // the default string that headerTemplateSize is based on
  char* headerStringPointer;

  headerStringPointer = headerString;


  // malloc the size of the header plus the actual width*height*maxvalBytes of our image,
  // times three for the three color channels
  unsigned char* ppmData = malloc(sizeof(unsigned char)*headerTotalSize +
                                                         maxvalBytes*p.w*p.h*3);

  /* This should instert a PPM header of appropriate size at the beginning of the
   * ppmData buffer. sprintf() will append a null terminator. Not a problem though,
   * since it's zero indexed, we should be able to just start writing our image data
   * in at ppmData[headerTotalSize], which will overwrite the null terminator */
  sprintf(ppmData, headerStringPointer, p.w, p.h, p.maxval);

  /* However, since we're internally using a Cartesian style coordinate system, we need
   * to flip it to the top left indexed PPM format */
  for( unsigned i = 0; i < p.h; ++i ) {
    for( unsigned j = 0; j < p.w; ++j ) {
      if(maxvalBytes == 1) {
        ppmData[headerTotalSize +
                (p.w*(i*3)+
                 (j*3))]   = (unsigned char)ppm_floatToPixel(p.r[p.w*(p.h-1-i)+j],
                                                             p.maxval);
        ppmData[headerTotalSize +
                (p.w*(i*3)+
                 (j*3)+1)] = (unsigned char)ppm_floatToPixel(p.g[p.w*(p.h-1-i)+j],
                                                             p.maxval);
        ppmData[headerTotalSize +
                (p.w*(i*3)+
                 (j*3)+2)] = (unsigned char)ppm_floatToPixel(p.b[p.w*(p.h-1-i)+j],
                                                             p.maxval);
      } else {
        ppm_splitShort(&(ppmData[headerTotalSize +
                                (p.w*(i*3*maxvalBytes) +
                                 (j*3*maxvalBytes))]), ppm_floatToPixel(p.r[p.w*(p.h-1-i)+j],
                                                                        p.maxval));
        ppm_splitShort(&(ppmData[headerTotalSize +
                                 (p.w*(i*3*maxvalBytes) +
                                  (j*3*maxvalBytes)+2)]), ppm_floatToPixel(p.g[p.w*(p.h-1-i)+j],
                                                                         p.maxval));

        ppm_splitShort(&(ppmData[headerTotalSize +
                                 (p.w*(i*3*maxvalBytes) +
                                  (j*3*maxvalBytes)+4)]), ppm_floatToPixel(p.b[p.w*(p.h-1-i)+j],
                                                                         p.maxval));
        // I'll make all this stuff readable later 

      }
    }
  }

  // We've got things laid out how we need, now just copy it to a file
  FILE* ppmFile = fopen(filename, "w");
  if(ppmFile == NULL) {
    printf("Error opening file for writing\n");
    free(ppmData);
    return 0;
  }

  fwrite(ppmData, sizeof(unsigned char), headerTotalSize + p.w*p.h*3*maxvalBytes, ppmFile);

  fclose(ppmFile);

  free(ppmData);

  return 1; // :)
}

