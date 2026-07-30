using MacSparkle;

namespace MacSparkleDotnetMacOSDemo;

[Register ("AppDelegate")]
public class AppDelegate : NSApplicationDelegate {
	public override void DidFinishLaunching (NSNotification notification)
	{
		try {
			NativeMethods.mac_sparkle_set_appcast_url("https://sparkle-project.org/files/sparkletestcast.xml");
			NativeMethods.mac_sparkle_init();
			
			// Configure automatic updates
			NativeMethods.mac_sparkle_set_automatic_check_for_updates(1);
			
			// Set update check interval to 1 hour (3600 seconds)
			NativeMethods.mac_sparkle_set_update_check_interval(3600);
			
			// Example: Get current settings
			var autoUpdatesEnabled = NativeMethods.mac_sparkle_get_automatic_check_for_updates() == 1;
			var updateInterval = NativeMethods.mac_sparkle_get_update_check_interval();
			var lastCheckTime = NativeMethods.mac_sparkle_get_last_check_time();
			
			System.Console.WriteLine($"Automatic updates: {autoUpdatesEnabled}");
			System.Console.WriteLine($"Update interval: {updateInterval} seconds");
			System.Console.WriteLine($"Last check time: {lastCheckTime}");
		}
		catch {
			// Swallow interop errors for the demo.
		}
	}

	public override void WillTerminate (NSNotification notification)
	{
		// No cleanup API is available in the current MacSparkle export.
	}
}
