using CoreGraphics;
using ObjCRuntime;
using AppKit;
using MacSparkle;

namespace MacSparkleDotnetMacOSDemo;

public partial class ViewController : NSViewController {
	private NSButton? checkForUpdateButton;

	protected ViewController (NativeHandle handle) : base (handle)
	{
		// This constructor is required if the view controller is loaded from a xib or a storyboard.
		// Do not put any initialization here, use ViewDidLoad instead.
	}

	public override void ViewDidLoad ()
	{
		base.ViewDidLoad ();

		checkForUpdateButton = new NSButton(new CGRect(20, 20, 180, 32)) {
			Title = "Check for Updates",
			BezelStyle = NSBezelStyle.Rounded,
			TranslatesAutoresizingMaskIntoConstraints = false,
		};
		checkForUpdateButton.Activated += OnCheckForUpdateClicked;

		View.AddSubview(checkForUpdateButton);
		checkForUpdateButton.TopAnchor.ConstraintEqualTo(View.TopAnchor, 20).Active = true;
		checkForUpdateButton.LeadingAnchor.ConstraintEqualTo(View.LeadingAnchor, 20).Active = true;
	}

	private void OnCheckForUpdateClicked (object? sender, EventArgs e)
	{
		try {
			NativeMethods.mac_sparkle_check_update_with_ui();
		}
		catch {
			// Swallow interop errors for the demo.
		}
	}

	public override NSObject RepresentedObject {
		get => base.RepresentedObject;
		set {
			base.RepresentedObject = value;

			// Update the view, if already loaded.
		}
	}
}
