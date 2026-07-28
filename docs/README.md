# libMacSparkle

Thin wrapper for Sparkle updater for macOS. This library provides a C API for integrating Sparkle's automatic update functionality into cross-platform applications (e.g., .NET, C++, etc.) on macOS.

## Overview

libMacSparkle wraps the [Sparkle framework](https://sparkle-project.org/) to provide a simple C interface for:

- Initializing updater
- Checking for updates manually

The API design is inspired by [WinSparkle](https://github.com/vslavik/winsparkle), providing a similar C interface for cross-platform applications.

## Building

Install dependencies.

```bash
swift package resolve
```

Build the library using the provided build script:

```bash
./build.sh
```

This will generate `libMacSparkle.dylib` in the build output directory.

## Info.plist Requirements

Your application's `Info.plist` file must include the following entries for Sparkle to function correctly:

### Required Entries

- **CFBundleIdentifier**: Your application's unique bundle identifier (e.g., `com.yourcompany.yourapp`)
- **CFBundleVersion**: The build version (e.g., `100` or `1.0.0`)
- **CFBundleShortVersionString**: The display version shown to users (e.g., `1.0.0`)
- **SUFeedURL**: The URL to your appcast feed.
- **SUPublicEDKey**: Your EdDSA public key for signature verification.

### Example Info.plist

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
```

## Public API

The library exposes the following C functions via `mac_sparkle.h`:

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

## Recommended Usage

The library is configured through your application's `Info.plist`. The available API functions should be used in this order:

1. **Initialization**:
   - `mac_sparkle_init()` - Initialize the updater after `Info.plist` configuration is in place

2. **Runtime** (as needed):
   - `mac_sparkle_check_update_with_ui()` - Trigger manual update checks (e.g., from a "Check for Updates" menu item)

## C# Usage Example

### Step 1: Define P/Invoke Declarations

Create a `NativeMethods.cs` file to import the C functions:

```csharp
using System.Runtime.InteropServices;

internal static class NativeMethods
{
    private const string LIB = "libMacSparkle.dylib";

    [DllImport(LIB, EntryPoint = "mac_sparkle_init", CallingConvention = CallingConvention.Cdecl)]
    public static extern void mac_sparkle_init();

    [DllImport(LIB, EntryPoint = "mac_sparkle_check_update_with_ui", CallingConvention = CallingConvention.Cdecl)]
    public static extern void mac_sparkle_check_update_with_ui();
}
```

### Step 2: Initialize on Application Startup

Call `mac_sparkle_init()` when your application starts:

```csharp
public class App
{
    public static void Main(string[] args)
    {
        try
        {
            NativeMethods.mac_sparkle_init();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to initialize Sparkle: {ex.Message}");
        }

        // Continue with your application startup...
    }
}
```

### Step 3: Check for Updates (Optional)

Add a "Check for Updates" menu item or button:

```csharp
private void OnCheckForUpdatesClicked(object sender, EventArgs e)
{
    try
    {
        NativeMethods.mac_sparkle_check_update_with_ui();
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Failed to check for updates: {ex.Message}");
    }
}
```

## Platform Considerations

- **macOS Only**: This library only works on macOS. Ensure you guard calls with platform checks:
  ```csharp
  if (OperatingSystem.IsMacOS())
  {
      // Call MacSparkle functions
  }
  ```

- **Library Placement**: Ensure `libMacSparkle.dylib` and `Sparkle.framework` are in your application's bundle or in a location where the system can find it (e.g., alongside your executable or in `@rpath`).

## Examples

See the `examples/csharp` directory for complete working examples:
- `MacSparkleAvaloniaUIDemo` - Avalonia UI example
- `MacSparkleDotnetMacOSDemo` - .NET macOS example

## License

See LICENSE file for details.
