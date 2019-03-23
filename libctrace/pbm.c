/// Functions for PBM files ///

#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <limits.h>
#include <assert.h>
#include "pbm.h"


// This is just for convenience and clarity. You don't have to use it.
ppm_t ppm_createPPM(float *r, float *g, float *b, unsigned w, unsigned h, uint16_t maxval) {
  ppm_t p = { r, g, b, w, h, maxval };
  return p;
}

// Takes a pointer dest and a short s. Splits the short into two bytes and
// puts them into the buffer pointed to by dest, big end first
void ppm_splitShort(unsigned char* dest, uint16_t s) {
  unsigned char upper, lower;
  lower = s & 0xFF;
  upper = (s >> 8) & 0xFF;
  dest[0] = upper;
  dest[1] = lower;
}

void ppm_writeHandle(ppm_t p, FILE* file) {

  // NO DYNAMICALLY ALLOCATED MEMORY, TIM
  assert( UINT_MAX/(p.w) >= (p.h) );

  const char* magicNum = "P6"; // magic number for the type of pbm file we use
  int maxvalBytes;             // either 1 or 2

  // File header
  fprintf(file, "%s %u %u %u ", magicNum, p.w, p.h, p.maxval);

  // How many bytes for maxval?
  if(p.maxval > 255)
    maxvalBytes = 2;
  else
    maxvalBytes = 1;

  // A tiny buffer to store an rgb value. if maxvalByte < 2, only the first 3 elements will be used
  unsigned char tinyBuffer[6];

  for(unsigned i = 0; i < p.h; ++i) {

    for(unsigned j = 0; j < p.w; ++j) {

      unsigned index = (p.w * (p.h-1)) - (i * p.w) + j;

      float r = p.r[index];
      float g = p.g[index];
      float b = p.b[index];

      // Populate the tiny buffer
      if(maxvalBytes == 1) {
        tinyBuffer[0] = (unsigned char) (((float)p.maxval) * r);
        tinyBuffer[1] = (unsigned char) (((float)p.maxval) * g);
        tinyBuffer[2] = (unsigned char) (((float)p.maxval) * b);
      } else {
        // this means we need to get a 2 byte value in there.
        // ppm format has the most significant byte first.
        // ppm_splitShort handles what we need.
        ppm_splitShort(&(tinyBuffer[0]), (uint16_t) (((float)p.maxval) * r));
        ppm_splitShort(&(tinyBuffer[2]), (uint16_t) (((float)p.maxval) * g));
        ppm_splitShort(&(tinyBuffer[4]), (uint16_t) (((float)p.maxval) * b));
      }

      fwrite(tinyBuffer, maxvalBytes, 3, file); // Good

    }
  }
}

void ppm_writeFile(ppm_t p, const char* filename) {
  FILE* file = fopen(filename, "wx");

  assert(file != NULL); // ERROR: File already exists

  ppm_writeHandle(p, file);

  fclose(file);
}

