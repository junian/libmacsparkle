#ifndef MAC_SPARKLE_H
#define MAC_SPARKLE_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

// Sets the appcast URL for Sparkle. Must be called before mac_sparkle_init.
void mac_sparkle_set_appcast_url(const char* url);

// Initializes the Sparkle updater. Must be called first time after UI started.
void mac_sparkle_init(void);

// Triggers a manual update check with user interface feedback.
void mac_sparkle_check_update_with_ui(void);

#ifdef __cplusplus
}
#endif

#endif
