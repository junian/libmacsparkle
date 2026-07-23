/*
 * MacSparkle - Sparkle updater wrapper for macOS
 *
 * C API modeled after WinSparkle (https://winsparkle.org/c-api/setup-lifecycle/)
 * for use from .NET and other languages via P/Invoke.
 */

#ifndef _macsparkle_h_
#define _macsparkle_h_

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

#ifdef BUILDING_MAC_SPARKLE
#define MAC_SPARKLE_API __attribute__((visibility("default")))
#else
#define MAC_SPARKLE_API
#endif

/**
 * @name Configuration functions
 *
 * Functions for setting up MacSparkle.
 *
 * All functions in this category can only be called @em before the first
 * call to mac_sparkle_init()!
 *
 * Typically, the application would configure MacSparkle on startup and then
 * call mac_sparkle_init(), all from its main thread.
 */
//@{

/**
 * Sets URL for the app's appcast.
 *
 * Only http and https schemes are supported.
 *
 * If this function isn't called by the app, the URL is obtained from the
 * host bundle's Info.plist `SUFeedURL` key.
 *
 * @param url URL of the appcast.
 *
 * @note Always use HTTPS feeds, do not use unencrypted HTTP! This is
 * necessary to prevent both leaking user information and preventing
 * various MITM attacks.
 *
 * @note See https://sparkle-project.org/documentation/publishing/ for
 * more information about appcast feeds.
 */
MAC_SPARKLE_API void mac_sparkle_set_appcast_url(const char *url);

//@}

#ifdef __cplusplus
}
#endif

#endif /* _macsparkle_h_ */
