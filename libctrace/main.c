/// Just using this to test the pbm stuff for now ///
#include "pbm.h"
#include <stdio.h>

int main(int argc, char **argv) {
  printf("Starting\n");
  unsigned w = 3, h = 3;
  float r[] = { 0.0, 1.0, 1.0,
                1.0, 0.0, 0.0,
                1.0, 0.0, 1.0
  };
  float g[] = { 1.0, 1.0, 0.0,
                0.0, 1.0, 0.0,
                1.0, 0.0, 0.0
  };
  float b[] = { 1.0, 0.0, 1.0,
                0.0, 0.0, 1.0,
                1.0, 0.0, 0.0
  };
  /* Once this gets turned into an image, it should look like
   * W B R
   * R G B
   * C Y M
   */
  ppm_t myimage = ppm_createPPM(r, g, b, w, h, 65535);
  ppm_exportFile(myimage, "myimage.ppm");
  printf("Ending\n");
  return 0;
}
