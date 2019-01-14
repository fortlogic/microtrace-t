#ifndef PBM_H
#define PBM_H

#include <stdint.h>

typedef struct ppm {
  float *r, *g, *b;
  unsigned w, h;
  uint16_t maxval;
}ppm_t;

ppm_t ppm_createPPM(float *r, float *g, float *b, unsigned w, unsigned h, uint16_t maxval);

int ppm_exportFile(ppm_t p, const char* filename);

#endif
