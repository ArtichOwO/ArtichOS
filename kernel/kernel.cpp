#include "../drivers/screen.h"

void main() {
    clear_screen();

    char * msg = (char *) "Hello, World! Welcome to \n\n"
                "  ___       _   _      _     _____ _____ \n"
                " / _ \\     | | (_)    | |   |  _  /  ___|\n"
                "/ /_\\ \\_ __| |_ _  ___| |__ | | | \\ `--. \n"
                "|  _  | '__| __| |/ __| '_ \\| | | |`--. \\\n"
                "| | | | |  | |_| | (__| | | \\ \\_/ /\\__/ /\n"
                "\\_| |_/_|   \\__|_|\\___|_| |_|\\___/\\____/ \n\n"
                "Please wait, there will be soon more things to do here ;3";

    kprint(msg, 0x02);
}
