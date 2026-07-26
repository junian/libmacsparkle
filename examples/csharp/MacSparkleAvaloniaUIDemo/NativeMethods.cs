using System.Runtime.InteropServices;

namespace MacSparkleDemo;

internal static class NativeMethods
{
    private const string LIB = "libMacSparkle.dylib";

    [DllImport(LIB, EntryPoint = "mac_sparkle_init", CallingConvention = CallingConvention.Cdecl)]
    public static extern void mac_sparkle_init();

    [DllImport(LIB, EntryPoint = "mac_sparkle_check_update_with_ui", CallingConvention = CallingConvention.Cdecl)]
    [return: MarshalAs(UnmanagedType.I1)]
    public static extern bool mac_sparkle_check_update_with_ui();
}
