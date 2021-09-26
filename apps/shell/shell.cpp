#include "shell.h"
#include "../../drivers/keyboard.h"
#include "../../drivers/screen.h"
#include "../application.h"
#include <string.h>

namespace shellapp {
int main(int argc, char * argv[]) {
	key_t key;
	std::Apps_Handler apps;
	char buffer[256];
	int exit_code;
	char exit_code_a[5];
	int i;

  char * exit_message = (char *) "\nProgram exited with code ";
  char * input_msg = (char *) "\nArtichOS $ ";
  char * no_cmd = (char *) "\nCommand not found!\n";

  while (true) {
    kprint(input_msg);
    i = 0;
    while (i < 256) {
      key = get_key();
      if (*key.value == '\n') {
        buffer[i] = '\0';
        break;
      } else if (*key.value == '\b') {
        if (i > 0) {
          kprint(key.value);
          i--;
        } else {
          /* Do nothing */
        }
      } else {
        kprint(key.value);
        buffer[i] = *key.value;
        i++;
      }
    }

    exit_code = apps.run_app(buffer);
    if (exit_code != 127) {
    	kprint(exit_message);
      itoa(exit_code, exit_code_a);
      kprint(exit_code_a);
      kprint((char *)"\n");
    } else {
    	kprint(no_cmd);
    }
  }

  return 0;
}
}
