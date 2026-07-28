namespace MacSparkleDotnetMacOSDemo;

[Register ("AppDelegate")]
public class AppDelegate : NSApplicationDelegate {
	public override void DidFinishLaunching (NSNotification notification)
	{
		try {
			NativeMethods.mac_sparkle_set_appcast_url("https://sparkle-project.org/files/sparkletestcast.xml");
			NativeMethods.mac_sparkle_init();
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
