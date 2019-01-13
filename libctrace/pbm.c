/// Functions for PBM files ///

#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
#include "pbm.h"

// This is just for convenience and clarity. You don't have to use it.
ppm_t ppm_createPPM(float *r, float *g, float *b, unsigned w, unsigned h) {
  ppm_t p = { r, g, b, w, h };
  return p;
}

int ppm_exportFile(ppm_t p, const char* filename) {

  /* The ppm header requires width and height to be in decimal/ascii,
   * ergo we need to know the number of digits (decimal places) they'll take up.
   * Rather than assume nobody wants an image that goes above some arbirary
   * range of decimal places we deem to be 'enough' we'll do it the proper way.
   * Yay! */
  unsigned widthDigits  = 1 + (unsigned)log10((double)(p.w));
  unsigned heightDigits = 1 + (unsigned)log10((double)(p.h));

  // strlen here will give us the size of a string NOT INCLUDING the null terminator
  unsigned headerTemplateSize = strlen("P6   255 ");

  // add that to the number of digits. This will be the total size of the header
  unsigned headerTotalSize = headerTemplateSize + widthDigits + heightDigits;

  // malloc the size of the header plus the actual width*height of our image,
  // times three for the three color channels

  /// DON'T FORGET TO FREE THIS! ///
  unsigned char* ppmData = malloc(sizeof(unsigned char)*(headerTotalSize +
                                                         p.w*p.h*3));

  /* This should instert a PPM header of appropriate size at the beginning of the
   * ppmData buffer. sprintf() will append a null terminator. Not a problem though,
   * since it's zero indexed, we should be able to just start writing our image data
   * in at ppmData[headerTotalSize], which will overwrite the null terminator */
  sprintf(ppmData, "P6 %u %u 255 ", p.w, p.h);

  /* However, since we're internally using a Cartesian style coordinate system, we need
   * to flip it to the top left indexed PPM format */
  for( unsigned i = 0; i < p.h; ++i ) {
    for( unsigned j = 0; j < p.w; ++j ) {
      /* If I'm not going crazy, this should make some degree of sense when you think about
       * it enough. We're taking the planar, bottom left indexed pixel buffers and
       * translating them to an interleaved, top left indexed version
       * I look forward to finding out why it segfaults... */
      ppmData[headerTotalSize + (p.w*(i*3)+(j*3))]   = ppm_floatToByte(p.r[p.w*(p.h-1-i)+j]);
      ppmData[headerTotalSize + (p.w*(i*3)+(j*3)+1)] = ppm_floatToByte(p.g[p.w*(p.h-1-i)+j]);
      ppmData[headerTotalSize + (p.w*(i*3)+(j*3)+2)] = ppm_floatToByte(p.b[p.w*(p.h-1-i)+j]);
    }
  }
  // We've got things laid out how we need, now just copy it to a file
  FILE* ppmFile = fopen(filename, "w");
  if(ppmFile == NULL) {
    printf("Error opening file for writing\n");
    free(ppmData); // almost forgot that. that was close...
    return 0;
  }
  fwrite(ppmData, sizeof(unsigned char), headerTotalSize + p.w*p.h*3, ppmFile);

  fclose(ppmFile);
  /// FREEING HERE ///
  free(ppmData);
  /* You know, are we supposed to be returning 1 on success, or is it for failure?
   * Standard library functions are 0 for success usually, but that doesn't make any intuitive
   * sense when you're putting it in an if statement. if(!foo()) seems like it should mean
   * "If foo() fails"... */
  // Anyway, let's just pray this works
  return 1;
}

unsigned char ppm_floatToByte(float f) {
  // returning a typecast of a nested ternary expression because I'm not okay
  return (unsigned char)(f < 0.0f ? 0.0f : (f > 1.0f ? 1.0f*255.0f : f*255.0f));
}
