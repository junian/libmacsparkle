#ifndef MAC_SPARKLE_H
#define MAC_SPARKLE_H

#include <stdbool.h>
#include <time.h>

#ifdef __cplusplus
extern "C" {
#endif

// Sets the appcast URL for Sparkle. Must be called before mac_sparkle_init.
void mac_sparkle_set_appcast_url(const char* url);

// Initializes the Sparkle updater. Must be called first time after UI started.
void mac_sparkle_init(void);

// Triggers a manual update check with user interface feedback.
void mac_sparkle_check_update_with_ui(void);

// Set automatic check for updates. 1 == true, 0 == false
void mac_sparkle_set_automatic_check_for_updates(int state);

// Get automatic check for updates state. 1 == true, 0 == false
int mac_sparkle_get_automatic_check_for_updates(void);

// Set update check interval (in seconds)
void mac_sparkle_set_update_check_interval(int interval);

// Get update check interval (in seconds)
int mac_sparkle_get_update_check_interval(void);

// Get last update check time (Unix timestamp). Returns -1 if never checked
time_t mac_sparkle_get_last_check_time(void);

#ifdef __cplusplus
}
#endif

#endif
