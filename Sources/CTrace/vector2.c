#include <math.h>
#include <stdarg.h>

#include "vector2.h"

const vector2_t vec2_zero = {0.0, 0.0};
const vector2_t vec2_unit_u = {1.0, 0.0};
const vector2_t vec2_unit_v = {0.0, 1.0};

vector2_t vec2_make(float u, float v) {
  vector2_t vec = {u, v};
  return vec;
}

float vec2_magnitude(vector2_t vec) {
  return sqrtf(vec2_dot(vec, vec));
}

vector2_t vec2_normalize(vector2_t vec) {
  vector2_t norm = vec2_scale(1.0 / vec2_magnitude(vec), vec);
  return norm;
}

vector2_t vec2_negate(vector2_t vec) {
  vector2_t opposite = {-vec.v, -vec.u};
  return opposite;
}

vector2_t vec2_scale(float n, vector2_t vec) {
  vector2_t scaled = {n * vec.u, n * vec.v};
  return scaled;
}

float vec2_dot(vector2_t vec1, vector2_t vec2) {
  float dot = (vec1.u * vec2.u) + (vec1.v * vec2.v);
  return dot;
}

float vec2_distance(vector2_t vec1, vector2_t vec2) {
  float dist = fabsf(vec2_magnitude(vec2_subtract(vec1, vec2)));
  return dist;
}

vector2_t vec2_add(vector2_t vec1, vector2_t vec2) {
  vector2_t sum = {vec1.u + vec2.u, vec1.v + vec2.v};
  return sum;
}

vector2_t vec2_subtract(vector2_t vec1, vector2_t vec2) {
  vector2_t diff = {vec1.u - vec2.u, vec1.v - vec2.v};
  return diff;
}

vector2_t vec2_addn(unsigned int count, ...) {
  va_list stupid_c_thing;
  va_start(stupid_c_thing, count);
  vector2_t sum = vec2_zero;

  for(unsigned int i = 0; i < count; ++i) {
    vector2_t vec = va_arg(stupid_c_thing, vector2_t);
    vec2_add(sum, vec);
  }

  va_end(stupid_c_thing);
  return sum;
}
