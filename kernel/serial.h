#ifndef DRIVERS_SERIAL_H
#define DRIVERS_SERIAL_H

#define PORT 0x3f8 // COM1

int init_serial(void);
int is_transmit_empty(void);
void write_serial(char a);
void write_serial_string(char * str);
int serial_received(void);
char read_serial(void);

#endif // DRIVERS_SERIAL_H
