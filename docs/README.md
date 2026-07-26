# libMacSparkle

Thin wrapper for Sparkle updater for macOS. This library provides a C API for integrating Sparkle's automatic update functionality into cross-platform applications (e.g., .NET, C++, etc.) on macOS.

## Overview

libMacSparkle wraps the [Sparkle framework](https://sparkle-project.org/) to provide a simple C interface for:
- Setting up update feeds (appcast URLs)
- Configuring security (EDDSA public keys)
- Setting app metadata
- Initializing and checking for updates
- Cleanup on application exit

## Building

Build the library using the provided build script:

```bash
./build.sh
```

This will generate `libMacSparkle.dylib` in the build output directory.

## Public API

The library exposes the following C functions via `mac_sparkle.h`:

### Configuration Functions

#### `mac_sparkle_set_appcast_url`
```c
bool mac_sparkle_set_appcast_url(const char *urlString);
```
Sets the URL of the Sparkle appcast feed that contains update information.

- **Parameters**: `urlString` - The URL to the appcast XML feed
- **Returns**: `true` on success, `false` if the URL is invalid or null
- **Note**: Must be called before `mac_sparkle_init()`

#### `mac_sparkle_set_eddsa_public_key`
```c
bool mac_sparkle_set_eddsa_public_key(const char *publicKey);
```
Sets the EdDSA public key used to verify update signatures for security.

- **Parameters**: `publicKey` - The EdDSA public key string
- **Returns**: `true` on success, `false` if the key is null
- **Note**: Must be called before `mac_sparkle_init()`

#### `mac_sparkle_set_app_details`
```c
bool mac_sparkle_set_app_details(const char *companyName, const char *appName, const char *versionString);
```
Sets application metadata used by Sparkle for update display.

- **Parameters**:
  - `companyName` - The company/organization name
  - `appName` - The application name
  - `versionString` - The current version string
- **Returns**: `true` on success, `false` if any parameter is null
- **Note**: Must be called before `mac_sparkle_init()`

### Lifecycle Functions

#### `mac_sparkle_init`
```c
bool mac_sparkle_init(void);
```
Initializes the Sparkle updater. Must be called after configuration functions.

- **Returns**: `true` on success
- **Note**: This starts the updater and enables automatic update checks

#### `mac_sparkle_check_update_with_ui`
```c
bool mac_sparkle_check_update_with_ui(void);
```
Triggers a manual update check with user interface feedback.

- **Returns**: `true` on success
- **Note**: Shows Sparkle's standard update UI to the user

#### `mac_sparkle_cleanup`
```c
bool mac_sparkle_cleanup(void);
```
Cleans up the updater state. Should be called before application exit.

- **Returns**: `true` on success
- **Note**: Resets the updater controller and clears state

## Recommended Usage Order

The API functions should be called in the following order:

1. **Configuration Phase** (on application startup):
   - `mac_sparkle_set_appcast_url()` - Set your appcast feed URL
   - `mac_sparkle_set_eddsa_public_key()` - Set your public key for signature verification
   - `mac_sparkle_set_app_details()` - Set company name, app name, and version

2. **Initialization**:
   - `mac_sparkle_init()` - Initialize the updater

3. **Runtime** (as needed):
   - `mac_sparkle_check_update_with_ui()` - Trigger manual update checks (e.g., from a "Check for Updates" menu item)

4. **Cleanup** (on application exit):
   - `mac_sparkle_cleanup()` - Clean up updater state

## C# Usage Example

### Step 1: Define P/Invoke Declarations

Create a `NativeMethods.cs` file to import the C functions:

```csharp
using System.Runtime.InteropServices;

internal static class NativeMethods
{
    private const string LIB = "libMacSparkle.dylib";

    [DllImport(LIB, EntryPoint = "mac_sparkle_set_appcast_url", 
               CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
    [return: MarshalAs(UnmanagedType.I1)]
    public static extern bool mac_sparkle_set_appcast_url([MarshalAs(UnmanagedType.LPStr)] string url);

    [DllImport(LIB, EntryPoint = "mac_sparkle_set_eddsa_public_key", 
               CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
    [return: MarshalAs(UnmanagedType.I1)]
    public static extern bool mac_sparkle_set_eddsa_public_key([MarshalAs(UnmanagedType.LPStr)] string key);

    [DllImport(LIB, EntryPoint = "mac_sparkle_set_app_details", 
               CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
    [return: MarshalAs(UnmanagedType.I1)]
    public static extern bool mac_sparkle_set_app_details(
        [MarshalAs(UnmanagedType.LPStr)] string companyName,
        [MarshalAs(UnmanagedType.LPStr)] string appName,
        [MarshalAs(UnmanagedType.LPStr)] string versionString);

    [DllImport(LIB, EntryPoint = "mac_sparkle_init", 
               CallingConvention = CallingConvention.Cdecl)]
    [return: MarshalAs(UnmanagedType.I1)]
    public static extern bool mac_sparkle_init();

    [DllImport(LIB, EntryPoint = "mac_sparkle_check_update_with_ui", 
               CallingConvention = CallingConvention.Cdecl)]
    [return: MarshalAs(UnmanagedType.I1)]
    public static extern bool mac_sparkle_check_update_with_ui();

    [DllImport(LIB, EntryPoint = "mac_sparkle_cleanup", 
               CallingConvention = CallingConvention.Cdecl)]
    [return: MarshalAs(UnmanagedType.I1)]
    public static extern bool mac_sparkle_cleanup();
}
```

### Step 2: Initialize on Application Startup

Call the configuration and initialization functions when your application starts:

```csharp
public class App
{
    public static void Main(string[] args)
    {
        // Configure Sparkle on app startup
        try
        {
            NativeMethods.mac_sparkle_set_appcast_url("https://example.com/updates/appcast.xml");
            NativeMethods.mac_sparkle_set_eddsa_public_key("your-eddsa-public-key-here");
            NativeMethods.mac_sparkle_set_app_details("Your Company", "Your App", "1.0.0");
            NativeMethods.mac_sparkle_init();
        }
        catch (Exception ex)
        {
            // Handle interop errors (e.g., library not found on non-macOS platforms)
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

### Step 4: Cleanup on Application Exit

Clean up the updater when your application exits:

```csharp
public class App
{
    protected override void OnExit()
    {
        try
        {
            NativeMethods.mac_sparkle_cleanup();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to cleanup Sparkle: {ex.Message}");
        }
        
        base.OnExit();
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

- **Library Placement**: Ensure `libMacSparkle.dylib` is in your application's bundle or in a location where the system can find it (e.g., alongside your executable or in `@rpath`).

## Examples

See the `examples/csharp` directory for complete working examples:
- `MacSparkleAvaloniaUIDemo` - Avalonia UI example
- `MacSparkleDotnetMacOSDemo` - .NET macOS example

## License

See LICENSE file for details.
