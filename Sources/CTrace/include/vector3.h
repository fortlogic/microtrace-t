#ifndef VECTOR3_H
#define VECTOR3_H

typedef struct vector3 {
  float i;
  float j;
  float k;
} vector3_t;

///
/// Interesting Vectors
///

const vector3_t vec3_zero;
const vector3_t vec3_unit_i;
const vector3_t vec3_unit_j;
const vector3_t vec3_unit_k;

///
/// Vector Construction
///

vector3_t vec3_make(float i, float j, float k);

///
/// Unary Operations
///

float vec3_magnitude(vector3_t vec);

vector3_t vec3_normalize(vector3_t vec);

vector3_t vec3_negate(vector3_t vec);

///
/// Binary Operations
///

vector3_t vec3_scale(float n, vector3_t vec);

float vec3_dot(vector3_t vec1, vector3_t vec2);

float vec3_distance(vector3_t vec1, vector3_t vec2);

vector3_t vec3_add(vector3_t vec1, vector3_t vec2);

vector3_t vec3_subtract(vector3_t vec1, vector3_t vec2);

///
/// N-Ary Operations
///

vector3_t vec3_addn(unsigned int count, ...);

vector3_t vec3_subtractn(unsigned int count, vector3_t vec, ...);

#endif
