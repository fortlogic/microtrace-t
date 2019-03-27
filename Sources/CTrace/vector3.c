#include <math.h>
#include <stdarg.h>

#include "vector3.h"

const vector3_t vec3_zero = {0.0, 0.0, 0.0};
const vector3_t vec3_unit_i = {1.0, 0.0, 0.0};
const vector3_t vec3_unit_j = {0.0, 1.0, 0.0};
const vector3_t vec3_unit_k = {0.0, 0.0, 1.0};

vector3_t vec3_make(float i, float j, float k) {
  vector3_t vec = {i, j, k};
  return vec;
}

float vec3_magnitude(vector3_t vec) {
  return sqrtf(vec3_dot(vec, vec));
}

vector3_t vec3_normalize(vector3_t vec) {
  vector3_t norm = vec3_scale(1.0 / vec3_magnitude(vec), vec);
  return norm;
}

vector3_t vec3_negate(vector3_t vec) {
  vector3_t opposite = {-vec.i, -vec.j, -vec.k};
  return opposite;
}

vector3_t vec3_scale(float n, vector3_t vec) {
  vector3_t scaled = {n * vec.i, n * vec.j, n * vec.k};
  return scaled;
}

float vec3_dot(vector3_t vec1, vector3_t vec2) {
  float dot = (vec1.i * vec2.i) + (vec1.j * vec2.j) + (vec1.k * vec2.k);
  return dot;
}

float vec3_distance(vector3_t vec1, vector3_t vec2) {
  float dist = fabsf(vec3_magnitude(vec3_subtract(vec1, vec2)));
  return dist;
}

vector3_t vec3_add(vector3_t vec1, vector3_t vec2) {
  vector3_t sum = {vec1.i + vec2.i, vec1.j + vec2.j, vec1.k + vec2.k};
  return sum;
}

vector3_t vec3_subtract(vector3_t vec1, vector3_t vec2) {
  vector3_t diff = {vec1.i - vec2.i, vec1.j - vec2.j, vec1.k - vec2.k};
  return diff;
}

vector3_t vec3_addn(unsigned int count, ...) {
  va_list stupid_c_thing;
  va_start(stupid_c_thing, count);
  vector3_t sum = vec3_zero;

  for(unsigned int i = 0; i < count; ++i) {
    vector3_t vec = va_arg(stupid_c_thing, vector3_t);
    vec3_add(sum, vec);
  }

  va_end(stupid_c_thing);
  return sum;
}
