#ifndef MAC_SPARKLE_H
#define MAC_SPARKLE_H

#include <stdbool.h>
#include <time.h>

#ifdef __cplusplus
extern "C" {
#endif

// All functions in this header must be called on the main thread.
// The URL is copied synchronously; the caller retains ownership of the
// buffer and may free it immediately after this function returns.
//
// Sets the appcast URL for Sparkle. Must be called before mac_sparkle_init.
void mac_sparkle_set_appcast_url(const char* url);

// Initializes the Sparkle updater. Must be called first time after UI started.
void mac_sparkle_init(void);

// Triggers a manual update check with user interface feedback.
void mac_sparkle_check_update_with_ui(void);

// Triggers an update check in the background without user interface feedback.
// Use with caution and generally not recommended: by default Sparkle schedules
// background checks automatically, and calling this manually may interfere
// with Sparkle's scheduler.
void mac_sparkle_check_update_without_ui(void);

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

// Sets an HTTP header to be sent with update requests. The header is stored in
// the updater's httpHeaders dictionary and applied to future requests.
// Both name and value are copied synchronously; the caller retains ownership of
// the buffers and may free them immediately after this function returns.
void mac_sparkle_set_http_header(const char* name, const char* value);

// Clears all HTTP headers previously set with mac_sparkle_set_http_header.
void mac_sparkle_clear_http_headers(void);

// Sets a callback to be called when the updater encounters an error.
// The callback is invoked on the main thread with no arguments.
// Pass NULL to clear the previously set callback.
typedef void (__cdecl *mac_sparkle_error_callback_t)();

void mac_sparkle_set_error_callback(
  mac_sparkle_error_callback_t callback
);

#ifdef __cplusplus
}
#endif

#endif
