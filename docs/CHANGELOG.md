# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-08-01

### Added
- New C API functions for HTTP headers on update requests:
  - `mac_sparkle_set_http_header()` - Set an HTTP header to be sent with update requests (appcast checks, release note downloads, and update downloads)
  - `mac_sparkle_clear_http_headers()` - Clear all HTTP headers previously set with `mac_sparkle_set_http_header()`
- New `mac_sparkle_check_update_without_ui()` C API function to check for updates in the background without user interface feedback
- New `mac_sparkle_set_error_callback()` C API function (and `mac_sparkle_error_callback_t` typedef) to set a callback invoked when the updater encounters an error

### Changed
- Documented main thread requirements for the C API functions in the header
- Updated README with documentation for the new API functions

## [1.1.0] - 2026-07-31

### Added
- New C API functions for automatic update management:
  - `mac_sparkle_set_automatic_check_for_updates()` - Enable/disable automatic update checks
  - `mac_sparkle_get_automatic_check_for_updates()` - Get current automatic update check state
  - `mac_sparkle_set_update_check_interval()` - Set the update check interval in seconds
  - `mac_sparkle_get_update_check_interval()` - Get the current update check interval
  - `mac_sparkle_get_last_check_time()` - Get the timestamp of the last update check

### Fixed
- Corrected initialization of updater delegate in SparkleUpdater

## [1.0.9] - 2025-07-25

### Added
- Initial release of libMacSparkle
- Basic C API for Sparkle integration:
  - `mac_sparkle_set_appcast_url()` - Set appcast URL programmatically
  - `mac_sparkle_init()` - Initialize the Sparkle updater
  - `mac_sparkle_check_update_with_ui()` - Trigger manual update check with UI
