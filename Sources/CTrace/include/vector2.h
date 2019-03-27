#ifndef VECTOR2_H
#define VECTOR2_H

typedef struct vector2 {
  float u;
  float v;
} vector2_t;

///
/// Interesting Vectors
///

const vector2_t vec2_zero;
const vector2_t vec2_unit_u;
const vector2_t vec2_unit_v;

///
/// Vector Construction
///

vector2_t vec2_make(float u, float v);

///
/// Unary Operations
///

float vec2_magnitude(vector2_t vec);

vector2_t vec2_normalize(vector2_t vec);

vector2_t vec2_negate(vector2_t vec);

///
/// Binary Operations
///

vector2_t vec2_scale(float n, vector2_t vec);

float vec2_dot(vector2_t vec1, vector2_t vec2);

float vec2_distance(vector2_t vec1, vector2_t vec2);

vector2_t vec2_add(vector2_t vec1, vector2_t vec2);

vector2_t vec2_subtract(vector2_t vec1, vector2_t vec2);

///
/// N-Ary Operations
///

vector2_t vec2_addn(unsigned int count, ...);

vector2_t vec2_subtractn(unsigned int count, vector2_t vec, ...);

#endif /* VECTOR2_H */
