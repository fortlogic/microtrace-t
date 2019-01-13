#ifndef PBM_H
#define PBM_H

typedef struct ppm {
  float *r, *g, *b;
  unsigned w, h;
}ppm_t;

ppm_t ppm_createPPM(float *r, float *g, float *b, unsigned w, unsigned h);

int ppm_exportFile(ppm_t p, const char* filename);

unsigned char ppm_floatToByte(float f);

#endif
