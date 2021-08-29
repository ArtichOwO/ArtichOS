#include "../drivers/screen.h"
#include "../drivers/keyboard.h"
#include "../stdlib/stdlib.h"
extern "C" {
#include "interrupts.h"
#include "apm.h"
}

void main() {
    apm::init();
    //clear_screen();

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
    int video_color_mode = 0;
    char * arrows = (char *) "\n>>> ";
    char * no_cmd = (char *) "\nCommand not found!\n";
    char hello_cmd[] = "hello";
    char colours_cmd[] = "colours";
    char shdwn_cmd[] = "shutdown";
    char switchc_cmd[] = "switchc";
    char * colours_msg = (char *) "\nColours! 0x00 to 0xFF, with the letter A:\n";
    char * shdwn_msg = (char *) "\nPress any key to confirm shutdown, bye-nee~~\n";
    char buffer[256];

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

        /* Commands: `hello`, `colours` and `shutdown` */
        if (std::strcmp(buffer, hello_cmd) == 0) {
            kprint(msg, 0x02);
        } else if (std::strcmp(buffer, colours_cmd) == 0) {
            kprint(colours_msg);
            for (i = 0; i < 0x100; i++) {
                kprint((char *)"A", i);
            }
        } else if (std::strcmp(buffer, shdwn_cmd) == 0) {
            kprint(shdwn_msg);
            get_key();
            apm::shutdown();
            return;
        } else if (std::strcmp(buffer, switchc_cmd) == 0) {
            if (video_color_mode == 0) {
                itr::scrn_toggle_blink();
                video_color_mode = 1;
            } else {
                itr::scrn_toggle_intensity();
                video_color_mode = 0;
            }
        } else {
            kprint(no_cmd, 0x04);
        }
    }
}
