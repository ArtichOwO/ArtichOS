#ifndef DRIVERS_KEYBOARD_H
#define DRIVERS_KEYBOARD_H

struct key_t {
	int id;
	char * name;
	char * value;
};

key_t get_key();

#endif // DRIVERS_KEYBOARD_H
