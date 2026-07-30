using System.Runtime.InteropServices;

namespace MacSparkle;

public static class NativeMethods
{
    private const string LIB = "libMacSparkle.dylib";

    [DllImport(LIB, EntryPoint = "mac_sparkle_set_appcast_url", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
    public static extern void mac_sparkle_set_appcast_url([MarshalAs(UnmanagedType.LPStr)] string url);
    
    [DllImport(LIB, EntryPoint = "mac_sparkle_init", CallingConvention = CallingConvention.Cdecl)]
    public static extern void mac_sparkle_init();

    [DllImport(LIB, EntryPoint = "mac_sparkle_check_update_with_ui", CallingConvention = CallingConvention.Cdecl)]
    public static extern void mac_sparkle_check_update_with_ui();

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
}
