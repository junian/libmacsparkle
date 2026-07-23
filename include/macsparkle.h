/*
 * MacSparkle - Sparkle updater wrapper for macOS
 *
 * C API modeled after WinSparkle (https://winsparkle.org/c-api/setup-lifecycle/)
 * for use from .NET and other languages via P/Invoke.
 */

#ifndef _macsparkle_h_
#define _macsparkle_h_

#include <stddef.h>
#include <wchar.h>

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

/**
 * Sets EdDSA public key.
 *
 * Only base64-encoded format is supported.
 *
 * Public key will be used to verify EdDSA signature of the update file.
 * It will be set only if it contains a valid EdDSA public key.
 *
 * If this function isn't called by the app, the public key is obtained from
 * the host bundle's Info.plist `SUPublicEDKey` key.
 *
 * @param pubkey EdDSA public key in base64 encoded format.
 *
 * @return 1 if a valid EdDSA public key is provided, 0 otherwise.
 */
MAC_SPARKLE_API int mac_sparkle_set_eddsa_public_key(const char *pubkey);

/**
 * Sets application metadata.
 *
 * Normally, these are taken from the host bundle's Info.plist, but if your
 * application doesn't use them for some reason, using this function is an
 * alternative.
 *
 * @param company_name Company name of the vendor.
 * @param app_name Application name. This is both shown to the user and used
 *                 in HTTP User-Agent header.
 * @param app_version Version of the app, as a string (e.g. "1.2" or "1.2rc1").
 *
 * @note @a company_name and @a app_name are used to determine the location of
 * MacSparkle settings when custom configuration storage is used.
 *
 * @see mac_sparkle_set_app_build_version()
 */
MAC_SPARKLE_API void mac_sparkle_set_app_details(
    const wchar_t *company_name,
    const wchar_t *app_name,
    const wchar_t *app_version);

//@}

#ifdef __cplusplus
}
#endif

#endif /* _macsparkle_h_ */
