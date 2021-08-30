#include "application.h"
#include <string.h>
#include "../drivers/screen.h"

#include "hello/hello.h"
#include "kernutil/kernutil.h"

namespace std {
	int Apps_Handler::run_app(char command[]) {
		this->app_id = -1;
		for (this->i = 0; this->i < APPS_QUANTITY; this->i++) {
			if (std::strcmp(command, this->apps_cmd[this->i]) == 0) {
				this->app_id = this->i;
				break;
			}
		}

		switch (this->app_id) {
			case 0:
				return helloapp::hello();
			case 1:
				return helloapp::colours();
			case 2:
				return helloapp::chars();
			case 3:
				return kernutilapp::shutdown();
			case 4:
				return kernutilapp::reboot();
			default:
				return 127;
		}
	}
}
