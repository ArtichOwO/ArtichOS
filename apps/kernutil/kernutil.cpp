#include "kernutil.h"
#include "../../drivers/screen.h"
#include "../../drivers/keyboard.h"
extern "C" {
#include "../../kernel/apm.h"
}

namespace kernutilapp {
int shutdown() {
  char * shdwn_msg = (char *) "\nPress any key to confirm shutdown, bye-nee~~\n";
	kprint(shdwn_msg);
  get_key();
  apm::shutdown();
  return 0;
}

int reboot() {
  char * reboot_msg = (char *) "\nPress any key to confirm reboot, see ya'~~\n";
  kprint(reboot_msg);
  get_key();
  apm::hardware_reset();
  return 0;
}
}
