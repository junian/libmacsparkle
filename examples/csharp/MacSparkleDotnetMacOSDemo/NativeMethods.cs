using System.Runtime.InteropServices;

namespace MacSparkleDotnetMacOSDemo;

internal static class NativeMethods
{
    private const string LIB = "libMacSparkle.dylib";

    [DllImport(LIB, EntryPoint = "mac_sparkle_set_appcast_url", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
    public static extern bool mac_sparkle_set_appcast_url([MarshalAs(UnmanagedType.LPStr)] string url);

    [DllImport(LIB, EntryPoint = "mac_sparkle_set_eddsa_public_key", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
    public static extern bool mac_sparkle_set_eddsa_public_key([MarshalAs(UnmanagedType.LPStr)] string key);

    [DllImport(LIB, EntryPoint = "mac_sparkle_set_app_details", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
    public static extern bool mac_sparkle_set_app_details(
        [MarshalAs(UnmanagedType.LPStr)] string companyName,
        [MarshalAs(UnmanagedType.LPStr)] string appName,
        [MarshalAs(UnmanagedType.LPStr)] string versionString);

    [DllImport(LIB, EntryPoint = "mac_sparkle_init", CallingConvention = CallingConvention.Cdecl)]
    public static extern bool mac_sparkle_init();

    [DllImport(LIB, EntryPoint = "mac_sparkle_check_update_with_ui", CallingConvention = CallingConvention.Cdecl)]
    public static extern bool mac_sparkle_check_update_with_ui();

    [DllImport(LIB, EntryPoint = "mac_sparkle_cleanup", CallingConvention = CallingConvention.Cdecl)]
    public static extern bool mac_sparkle_cleanup();
}
