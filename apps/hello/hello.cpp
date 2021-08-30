#include "hello.h"
#include "../../drivers/screen.h"

namespace helloapp {
  int hello() {
  	char * msg = (char *) "\nHello, World! Welcome to \n\n"
                  "  ___       _   _      _     _____ _____ \n"
                  " / _ \\     | | (_)    | |   |  _  /  ___|\n"
                  "/ /_\\ \\_ __| |_ _  ___| |__ | | | \\ `--. \n"
                  "|  _  | '__| __| |/ __| '_ \\| | | |`--. \\\n"
                  "| | | | |  | |_| | (__| | | \\ \\_/ /\\__/ /\n"
                  "\\_| |_/_|   \\__|_|\\___|_| |_|\\___/\\____/ \n\n"
                  "Please wait, there will be soon more things to do here ;3\n\n";

    kprint(msg, 0x02);
    return 0;
  }

  int colours() {
    kprint((char *)"\nColours! 0x00 to 0xFF, with the letter A:\n");
    for (int i = 0; i < 0x100; i++) {
        kprint((char *)"A", i);
    }
    return 0;
  }

  int chars() {
    kprint((char *)"\nCharacters! 0x00 to 0xFF:\n");
    for (int i = 0; i < 0x100; i++) {
        char character[2];
        character[0] = i;
        character[1] = '\0';
        kprint(&character[0], 0x0e);
    }
    return 0;
  }
}
