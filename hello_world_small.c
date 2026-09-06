#include "system.h"
#include "unistd.h"

int main() {
  volatile int * pwm_period = (int *) PWM_BASE;
  volatile int * pwm_duty   = (int *) (PWM_BASE + 4);
  volatile int * sw_ptr     = (int *) SWITCH_BASE;
  volatile int * led_ptr    = (int *) LED_BASE;

  int sw_value;

  // periode : 50000 cycles a 50 MHz = 1 kHz
  *pwm_period = 50000;

  while (1) {
    sw_value = *sw_ptr;

    // les switches pilotent les 7 LED simples
    *led_ptr = sw_value;

    // et la luminosite de la 8e : 16 niveaux
    *pwm_duty = (sw_value * 50000) / 16;

    usleep(10000);
  }

  return 0;
}
