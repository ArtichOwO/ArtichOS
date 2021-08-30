extern "C" {
#include "apm.h"
}
#include "../apps/hello/hello.h"
#include "../apps/shell/shell.h"

void main() {
  apm::init();
  //clear_screen();

  char * no_args[0];

  helloapp::hello();
  shellapp::main(0, no_args);
}
