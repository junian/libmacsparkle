<div align="center">

<!-- omit from toc -->
# libMacSparkle

Thin wrapper for Sparkle updater for macOS. This library provides a C API for integrating Sparkle's automatic update functionality into cross-platform applications (e.g., .NET, Rust, Go, etc.) on macOS.

[![libMacSparkle on GitHub](https://img.shields.io/badge/GitHub-%23121011.svg?logo=github&logoColor=white&style=for-the-badge)][github]
[![Download Latest libMacSparkle dylib](https://img.shields.io/github/release/junian/libmacsparkle.svg?style=for-the-badge)][download-latest]
[![Download Latest libMacSparkle dylib](https://img.shields.io/github/downloads/junian/libmacsparkle/total.svg?style=for-the-badge)][download-latest]
[![Buy me a coffee](https://img.shields.io/badge/Support-Buy%20Me%20A%20Coffee-FFDD00?logo=buymeacoffee&style=for-the-badge "Buy me a coffee")](https://www.junian.dev/coffee/)

</div>

<details open>
    <summary>Table of Contents</summary>

- [Overview](#overview)
- [Quickstart](#quickstart)
  - [Step 1: Download Dependencies](#step-1-download-dependencies)
  - [Step 2: Configure Info.plist](#step-2-configure-infoplist)
  - [Step 3: Create a Wrapper Class (C# Example)](#step-3-create-a-wrapper-class-c-example)
  - [Step 4: Initialize on Application Startup](#step-4-initialize-on-application-startup)
  - [Step 5: Configure Update Settings (Optional)](#step-5-configure-update-settings-optional)
  - [Step 6: Check for Updates (Optional)](#step-6-check-for-updates-optional)
- [Development](#development)
- [Public API](#public-api)
  - [`mac_sparkle_set_appcast_url`](#mac_sparkle_set_appcast_url)
  - [`mac_sparkle_init`](#mac_sparkle_init)
  - [`mac_sparkle_check_update_with_ui`](#mac_sparkle_check_update_with_ui)
  - [`mac_sparkle_check_update_without_ui`](#mac_sparkle_check_update_without_ui)
  - [`mac_sparkle_set_automatic_check_for_updates`](#mac_sparkle_set_automatic_check_for_updates)
  - [`mac_sparkle_get_automatic_check_for_updates`](#mac_sparkle_get_automatic_check_for_updates)
  - [`mac_sparkle_set_update_check_interval`](#mac_sparkle_set_update_check_interval)
  - [`mac_sparkle_get_update_check_interval`](#mac_sparkle_get_update_check_interval)
  - [`mac_sparkle_get_last_check_time`](#mac_sparkle_get_last_check_time)
  - [`mac_sparkle_set_http_header`](#mac_sparkle_set_http_header)
  - [`mac_sparkle_clear_http_headers`](#mac_sparkle_clear_http_headers)
  - [`mac_sparkle_set_error_callback`](#mac_sparkle_set_error_callback)
- [Platform Considerations](#platform-considerations)
- [Examples](#examples)
- [License](#license)

</details>

## Overview

libMacSparkle wraps the [Sparkle framework](https://sparkle-project.org/) to provide a simple C interface for:

- Setting appcast URL programmatically
- Initializing the updater
- Checking for updates manually
- Configuring automatic update checks
- Setting and getting update check intervals
- Retrieving last update check time
- Managing automatic update preferences
- Setting HTTP headers for update requests

The API design is inspired by [WinSparkle](https://github.com/vslavik/winsparkle), providing a similar C interface for cross-platform applications.

See [changelog] for full details.

## Quickstart

### Step 1: Download Dependencies

1. Download **Sparkle.framework** from the [official Sparkle website](https://sparkle-project.org/)
2. Download the latest **libMacSparkle** zip file from [latest GitHub Releases](https://github.com/junian/libmacsparkle/releases/latest/)

Extract both and place them in your application's bundle or alongside your executable.

### Step 2: Configure Info.plist

Your application's `Info.plist` file must include the following entries for Sparkle to function correctly:

**Required Entries:**

- **CFBundleIdentifier**: Your application's unique bundle identifier (e.g., `com.yourcompany.yourapp`)
- **CFBundleVersion**: The build version (e.g., `100` or `1.0.0`)
- **CFBundleShortVersionString**: The display version shown to users (e.g., `1.0.0`)
- **SUFeedURL**: The URL to your appcast feed. Can be overridden using `mac_sparkle_set_appcast_url()`
- **SUPublicEDKey**: Your EdDSA public key for signature verification.

**Optional Sparkle Entries:**

- **SUEnableAutomaticChecks**: Enable/disable automatic update checks (default: `YES`). Can be overridden using `mac_sparkle_set_automatic_check_for_updates()`
- **SUUpdateCheckInterval**: Update check interval in seconds (default: `86400` for daily). Can be overridden using `mac_sparkle_set_update_check_interval()`
- **SUAllowsAutomaticUpdates**: Allow automatic installation of updates (default: `NO`)
- **SUAutomaticallyUpdates**: Automatically install updates without user interaction (default: `NO`)
- **SUEnableSystemProfiling**: Enable system profiling for anonymous usage data (default: `NO`)
- **SUSendProfileInfo**: Send system profile information with update checks (default: `NO`)
- **SUShowReleaseNotes**: Show release notes when updates are available (default: `YES`)
- **SUEnableDownloaderService**: Use Sparkle's built-in downloader service (default: `YES`)
- **SUScheduledCheckInterval**: Background scheduled check interval in seconds (default: `86400`)

**Example Info.plist:**

```xml
<key>CFBundleIdentifier</key>
<string>com.yourcompany.yourapp</string>
<key>CFBundleVersion</key>
<string>1.0.0</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>

<key>SUFeedURL</key>
<string>https://example.com/updates/appcast.xml</string>
<key>SUPublicEDKey</key>
<string>your-eddsa-public-key-here</string>

<key>SUEnableAutomaticChecks</key>
<true/>
<key>SUUpdateCheckInterval</key>
<integer>86400</integer>
```

### Step 3: Create a Wrapper Class (C# Example)

Create a wrapper class to handle P/Invoke calls and initialization:

```csharp
using System.Runtime.InteropServices;

internal static class MacSparkleWrapper
{
    private const string LIB = "libMacSparkle.dylib";

    [DllImport(LIB, EntryPoint = "mac_sparkle_set_appcast_url", CallingConvention = CallingConvention.Cdecl)]
    public static extern void mac_sparkle_set_appcast_url([MarshalAs(UnmanagedType.LPStr)] string url);

    [DllImport(LIB, EntryPoint = "mac_sparkle_init", CallingConvention = CallingConvention.Cdecl)]
    public static extern void mac_sparkle_init();

    [DllImport(LIB, EntryPoint = "mac_sparkle_check_update_with_ui", CallingConvention = CallingConvention.Cdecl)]
    public static extern void mac_sparkle_check_update_with_ui();

    [DllImport(LIB, EntryPoint = "mac_sparkle_check_update_without_ui", CallingConvention = CallingConvention.Cdecl)]
    public static extern void mac_sparkle_check_update_without_ui();

    [DllImport(LIB, EntryPoint = "mac_sparkle_set_automatic_check_for_updates", CallingConvention = CallingConvention.Cdecl)]
    public static extern void mac_sparkle_set_automatic_check_for_updates(int state);

    [DllImport(LIB, EntryPoint = "mac_sparkle_get_automatic_check_for_updates", CallingConvention = CallingConvention.Cdecl)]
    public static extern int mac_sparkle_get_automatic_check_for_updates();

    [DllImport(LIB, EntryPoint = "mac_sparkle_set_update_check_interval", CallingConvention = CallingConvention.Cdecl)]
    public static extern void mac_sparkle_set_update_check_interval(int interval);

    [DllImport(LIB, EntryPoint = "mac_sparkle_get_update_check_interval", CallingConvention = CallingConvention.Cdecl)]
    public static extern int mac_sparkle_get_update_check_interval();

    [DllImport(LIB, EntryPoint = "mac_sparkle_get_last_check_time", CallingConvention = CallingConvention.Cdecl)]
    public static extern long mac_sparkle_get_last_check_time();

    [DllImport(LIB, EntryPoint = "mac_sparkle_set_http_header", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
    public static extern void mac_sparkle_set_http_header([MarshalAs(UnmanagedType.LPStr)] string name, [MarshalAs(UnmanagedType.LPStr)] string value);

    [DllImport(LIB, EntryPoint = "mac_sparkle_clear_http_headers", CallingConvention = CallingConvention.Cdecl)]
    public static extern void mac_sparkle_clear_http_headers();

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    public delegate void MacSparkleErrorCallback();

    [DllImport(LIB, EntryPoint = "mac_sparkle_set_error_callback", CallingConvention = CallingConvention.Cdecl)]
    public static extern void mac_sparkle_set_error_callback(MacSparkleErrorCallback callback);

    public static void Initialize(string appcastUrl)
    {
        mac_sparkle_set_appcast_url(appcastUrl);
        mac_sparkle_init();
    }

    public static void CheckForUpdates()
    {
        mac_sparkle_check_update_with_ui();
    }
}
```

### Step 4: Initialize on Application Startup

```csharp
public class App
{
    public static void Main(string[] args)
    {
        try
        {
            MacSparkleWrapper.Initialize("https://example.com/updates/appcast.xml");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to initialize Sparkle: {ex.Message}");
        }

        // Continue with your application startup...
    }
}
```

### Step 5: Configure Update Settings (Optional)

You can configure automatic update checking and intervals:

```csharp
public static void SetAutomaticUpdates(bool enabled)
{
    try
    {
        mac_sparkle_set_automatic_check_for_updates(enabled ? 1 : 0);
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Failed to set automatic updates: {ex.Message}");
    }
}

public static bool GetAutomaticUpdates()
{
    try
    {
        return mac_sparkle_get_automatic_check_for_updates() == 1;
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Failed to get automatic updates state: {ex.Message}");
    }
    return false;
}

public static void SetUpdateCheckInterval(int seconds)
{
    try
    {
        mac_sparkle_set_update_check_interval(seconds);
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Failed to set update interval: {ex.Message}");
    }
}

public static int GetUpdateCheckInterval()
{
    try
    {
        return mac_sparkle_get_update_check_interval();
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Failed to get update interval: {ex.Message}");
    }
    return 86400; // Default 24 hours
}

public static long GetLastCheckTime()
{
    try
    {
        return mac_sparkle_get_last_check_time();
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Failed to get last check time: {ex.Message}");
    }
    return -1;
}
```

### Step 6: Check for Updates (Optional)

Add a "Check for Updates" menu item or button:

```csharp
private void OnCheckForUpdatesClicked(object sender, EventArgs e)
{
    try
    {
        MacSparkleWrapper.CheckForUpdates();
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Failed to check for updates: {ex.Message}");
    }
}
```

## Development

Install dependencies.

```bash
swift package resolve
```

Build the library using the provided build script:

```bash
./build.sh
```

This will generate `libMacSparkle.dylib` in the `.build/universal/release` directory.

## Public API

The library exposes the following C functions via `mac_sparkle.h`:

### `mac_sparkle_set_appcast_url`

```c
void mac_sparkle_set_appcast_url(const char* url);
```

Sets the appcast URL for Sparkle. This allows you to programmatically set the feed URL instead of relying on `Info.plist`. Must be called before `mac_sparkle_init`.

### `mac_sparkle_init`

```c
void mac_sparkle_init(void);
```

Initializes the Sparkle updater. Must be called first time after UI started.

### `mac_sparkle_check_update_with_ui`

```c
void mac_sparkle_check_update_with_ui(void);
```

Triggers a manual update check with user interface feedback.

### `mac_sparkle_check_update_without_ui`

```c
void mac_sparkle_check_update_without_ui(void);
```

Triggers an update check in the background without user interface feedback.

> **Caution**: Use this function with caution and generally not recommended. By default Sparkle schedules background checks automatically, and calling this manually may interfere with Sparkle's scheduler.

### `mac_sparkle_set_automatic_check_for_updates`

```c
void mac_sparkle_set_automatic_check_for_updates(int state);
```

Sets whether Sparkle should automatically check for updates. Pass `1` for true, `0` for false.

### `mac_sparkle_get_automatic_check_for_updates`

```c
int mac_sparkle_get_automatic_check_for_updates(void);
```

Gets the current automatic update check state. Returns `1` if enabled, `0` if disabled.

### `mac_sparkle_set_update_check_interval`

```c
void mac_sparkle_set_update_check_interval(int interval);
```

Sets the update check interval in seconds. The default is 86400 seconds (24 hours).

### `mac_sparkle_get_update_check_interval`

```c
int mac_sparkle_get_update_check_interval(void);
```

Gets the current update check interval in seconds.

### `mac_sparkle_get_last_check_time`

```c
time_t mac_sparkle_get_last_check_time(void);
```

Gets the last update check time as a Unix timestamp. Returns `-1` if updates have never been checked.

### `mac_sparkle_set_http_header`

```c
void mac_sparkle_set_http_header(const char* name, const char* value);
```

Sets an HTTP header to be sent with update requests (appcast checks, release note downloads, and update downloads). The header is stored on the updater's `httpHeaders` dictionary; calling it again with the same name replaces the previous value. Pass `NULL` for either argument to ignore the call.

### `mac_sparkle_clear_http_headers`

```c
void mac_sparkle_clear_http_headers(void);
```

Clears all HTTP headers previously set using `mac_sparkle_set_http_header`.

### `mac_sparkle_set_error_callback`

```c
typedef void (__cdecl *mac_sparkle_error_callback_t)();

void mac_sparkle_set_error_callback(
  mac_sparkle_error_callback_t callback
);
```

Sets a callback to be called when the updater encounters an error. The callback is invoked on the main thread with no arguments. Pass `NULL` to clear the previously set callback. The callback is not invoked for the normal "no update found" outcome or for a user-canceled installation.

## Platform Considerations

- **macOS Only**: This library only works on macOS.

- **Library Placement**: Ensure `libMacSparkle.dylib` and `Sparkle.framework` are in your application's bundle or in a location where the system can find it (e.g., alongside your executable or in `@rpath`).

## Examples

See the [`examples/dotnet`][examples-dotnet] directory for complete working examples:
- [`MacSparkleAvaloniaUIDemo`][examples-dotnet-avaloniaui] - Avalonia UI example
- [`MacSparkleDotnetMacOSDemo`][examples-dotnet-macos] - .NET macOS example

## License

See [LICENSE](https://github.com/junian/libmacsparkle/blob/master/LICENSE) file for details.

[github]: https://github.com/junian/libmacsparkle "libMacSparkle on GitHub"
[download-latest]: https://github.com/junian/libmacsparkle/releases/latest "Download latest libMacSparkle.dylib"
[changelog]: https://github.com/junian/libmacsparkle/blob/master/docs/CHANGELOG.md "View Changelog"
[examples-dotnet]: https://github.com/junian/libmacsparkle/tree/master/examples/dotnet
[examples-dotnet-avaloniaui]: https://github.com/junian/libmacsparkle/tree/master/examples/dotnet/MacSparkleAvaloniaUIDemo
[examples-dotnet-macos]: https://github.com/junian/libmacsparkle/tree/master/examples/dotnet/MacSparkleDotnetMacOSDemo
