#include "keyboard.h"
extern "C" {
#include	"../kernel/interrupts.h"
}

char * kbd_map_names_azerty[] {
  /* AZERTY, NOP means unused */
	"NOP0", "ESC", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "NOP1", "NOP2", "BACK", 
	"TAB", "a", "z", "e", "r", "t", "y", "u", "i", "o", "p", "NOP3", "NOP4", "NL", "NOP5",
	"q", "s", "d", "f", "g", "h", "j", "k", "l", "m", "NOP6", "NOP7", "NOP8",
	"NOP9", "w", "x", "c", "v", "b", "n", "?", ".", "/", "+", "NOP10", "*", "NOP11",
	"SPACE", "NOP12", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "NOP13", 
	"NOP14", "HOME", "UP", "PGUP", "-",
	"LEFT", "OK", "RIGHT", "+", "END", "DOWN", "PGDOWN", "INSERT", "DEL"
};

char * kbd_map_values_azerty[] {
  /* AZERTY, NOP means unused */
	"NOP0", "\e", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "NOP1", "NOP2", "\b", 
	"TAB", "a", "z", "e", "r", "t", "y", "u", "i", "o", "p", "NOP3", "NOP4", "\n", "NOP5",
	"q", "s", "d", "f", "g", "h", "j", "k", "l", "m", "NOP6", "NOP7", "NOP8",
	"NOP9", "w", "x", "c", "v", "b", "n", "?", ".", "/", "+", "NOP10", "*", "NOP11",
	" ", "NOP12", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "NOP13", 
	"NOP14", "HOME", "UP", "PGUP", "-",
	"LEFT", "OK", "RIGHT", "+", "END", "DOWN", "PGDOWN", "INSERT", "\b"
};

key_t get_key() {
	key_t key; 
	key.id = (itr::kbd_get_key() >> 8) & 0xFF;
	key.name = (char *)kbd_map_names_azerty[key.id];
	key.value = (char *)kbd_map_values_azerty[key.id];
	return key;
}
