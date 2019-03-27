#ifndef XFORM2_H
#define XFORM2_H

#include "vector2.h"

typedef struct xform2 {
  vector2_t basisU;

  vector2_t basisV;

  vector2_t offset;
} xform2_t;

const xform2_t identity2;

xform2_t xform2_make_translation(float du, float dv);
xform2_t xform2_make_rotation(float theta);

xform2_t xform2_translate(xform2_t f, float du, float dv);
xform2_t xform2_rotate(xform2_t f, float theta);

xform2_t xform2_compose(xform2_t f, xform2_t g);

vector2_t xform2_project(xform2_t f, vector2_t vec);

#endif
