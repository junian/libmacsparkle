#ifndef MAC_SPARKLE_H
#define MAC_SPARKLE_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

void mac_sparkle_set_appcast_url(const char *urlString);
bool mac_sparkle_set_eddsa_public_key(const char *publicKey);
void mac_sparkle_set_app_details(const char *companyName, const char *appName, const char *versionString);
void mac_sparkle_init(void);
bool mac_sparkle_check_update_with_ui(void);
void mac_sparkle_cleanup(void);

#ifdef __cplusplus
}
#endif

#endif
