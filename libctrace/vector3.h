#ifndef VECTOR3_H
#define VECTOR3_H

typedef struct vector3 {
  float i;
  float j;
  float k;
}vector3_t;

///
/// Interesting Vectors
///

const vector3_t zero3;
const vector3_t unit3_i;
const vector3_t unit3_j;
const vector3_t unit3_k;

///
/// Unary Operations
///

float vec3_length(vector3_t vec);

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
