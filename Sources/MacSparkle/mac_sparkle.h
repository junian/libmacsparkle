#ifndef MAC_SPARKLE_H
#define MAC_SPARKLE_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

bool mac_sparkle_set_appcast_url(const char *urlString);
bool mac_sparkle_set_eddsa_public_key(const char *publicKey);
bool mac_sparkle_set_app_details(const char *companyName, const char *appName, const char *versionString);
bool mac_sparkle_init(void);
bool mac_sparkle_check_update_with_ui(void);
bool mac_sparkle_cleanup(void);

#ifdef __cplusplus
}
#endif

#endif
