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
