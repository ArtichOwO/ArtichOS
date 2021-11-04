#ifndef DRIVERS_SERIAL_H
#define DRIVERS_SERIAL_H

#define PORT 0x3f8 // COM1

int init_serial();
int is_transmit_empty();
void write_serial(char a);
void write_serial_string(char * str);
int serial_received();
char read_serial();

#endif // DRIVERS_SERIAL_H
