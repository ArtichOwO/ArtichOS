#ifndef APP_APPLICATION_H
#define APP_APPLICATION_H

#define APPS_QUANTITY 5

namespace std {
class Apps_Handler {
	char * apps_cmd[APPS_QUANTITY] {
		"hello",
		"colours",
		"chars",
		"shutdown",
		"reboot",
	};
	int i;
	int app_id;

	public:
		int run_app(char command[]);
};
}

#endif // APP_APPLICATION_H
