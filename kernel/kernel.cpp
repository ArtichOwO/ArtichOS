void main() {
    /* Assuming we're on a colored screen
     * will add this -> https://wiki.osdev.org/Detecting_Colour_and_Monochrome_Monitors
     */
    char * video_memory = (char *) 0xb8000;
    char * msg = (char *)"Hello, World!";

    for (char c = *msg; c; c=*++msg) {
        *video_memory = c;
        video_memory++;video_memory++;
    }
}
