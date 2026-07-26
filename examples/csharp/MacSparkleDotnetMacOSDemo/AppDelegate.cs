namespace MacSparkleDotnetMacOSDemo;

[Register ("AppDelegate")]
public class AppDelegate : NSApplicationDelegate {
	public override void DidFinishLaunching (NSNotification notification)
	{
		try {
			NativeMethods.mac_sparkle_set_appcast_url("https://sparkle-project.org/files/sparkletestcast.xml");
			NativeMethods.mac_sparkle_set_eddsa_public_key("test-public-key");
			NativeMethods.mac_sparkle_set_app_details("Example Company", "Example App", "1.2.3");
			NativeMethods.mac_sparkle_init();
		}
		catch {
			// Swallow interop errors for the demo.
		}
	}

	public override void WillTerminate (NSNotification notification)
	{
		try {
			NativeMethods.mac_sparkle_cleanup();
		}
		catch {
			// Swallow interop errors for the demo.
		}
	}
}
