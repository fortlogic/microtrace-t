#include <math.h>
#include "xform2.h"
#include "vector2.h"

const xform2_t identity2 = {{1.0, 0.0},
                            {0.0, 1.0},
                            {0.0, 0.0}};

xform2_t xform2_make_translation(float du, float dv) {
  xform2_t f = identity2;
  f.offset.u = du;
  f.offset.v = dv;
  return f;
}

xform2_t xform2_make_rotation(float theta) {
  xform2_t f = identity2;
  f.basisU.u = cos((double)theta);
  f.basisU.v = sin((double)theta);
  f.basisV.u = -sin((double)theta);
  f.basisV.v = cos((double)theta);
  return f;
}

xform2_t xform2_translate(xform2_t f, float du, float dv) {
  f.offset.u += du;
  f.offset.v += dv;
  return f;
}

xform2_t xform2_rotate(xform2_t f, float theta) {
  return identity2;
}

xform2_t xform2_compose(xform2_t f, xform2_t g) {
  return identity2;
}

vector2_t xform2_project(xform2_t f, vector2_t vec) {
  return vec;
}
