#include "../drivers/screen.h"
#include "../drivers/keyboard.h"
#include "../stdlib/stdlib.h"

void main() {
    clear_screen();

    char * msg = (char *) "\nHello, World! Welcome to \n\n"
                "  ___       _   _      _     _____ _____ \n"
                " / _ \\     | | (_)    | |   |  _  /  ___|\n"
                "/ /_\\ \\_ __| |_ _  ___| |__ | | | \\ `--. \n"
                "|  _  | '__| __| |/ __| '_ \\| | | |`--. \\\n"
                "| | | | |  | |_| | (__| | | \\ \\_/ /\\__/ /\n"
                "\\_| |_/_|   \\__|_|\\___|_| |_|\\___/\\____/ \n\n"
                "Please wait, there will be soon more things to do here ;3\n\n";

    kprint(msg, 0x02);

    /*
     * Some tests, will remove it soon
     */
    key_t key;
    int i;
    char * arrows = (char *) "\n>>> ";
    char * no_cmd = (char *) "\nCommand not found!\n";
    char hello_cmd[] = "hello";
    char buffer[256];

    char * i_msg;

    while (true) {
        kprint(arrows);
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

        /* Yes, the only command available is "hello" */
        if (std::strcmp(buffer, hello_cmd) == 0) {
            kprint(msg, 0x02);
        } else {
            kprint(no_cmd, 0x04);
        }
    }
}
