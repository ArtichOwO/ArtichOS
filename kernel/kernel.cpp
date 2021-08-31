extern "C" {
#include "apm.h"
}
#include "../apps/hello/hello.h"
#include "../apps/shell/shell.h"
#include "../drivers/serial.h"

void main() {
  init_serial();
  write_serial_string((char *)"Jumped to main, successfully initialized serial port COM1! \n"
                              "Welcome to ArtichOS! \n"
                              "Initializing APM... \n");
  apm::init();
  //clear_screen();
  write_serial_string((char *)"Done! \nRunning `hello`... \n");
  char * no_args[0];
  helloapp::hello();
  write_serial_string((char *)"Running `shell`...\n");
  shellapp::main(0, no_args);
  write_serial_string((char *)"Exited `shell`!\n");
}
