using CoreGraphics;
using ObjCRuntime;
using AppKit;
using Foundation;
using MacSparkle;

namespace MacSparkleDotnetMacOSDemo;

public partial class ViewController : NSViewController {
	private NSButton? checkForUpdateButton;
	private NSButton? automaticUpdatesCheckBox;
	private NSTextField? updateIntervalLabel;
	private NSTextField? lastCheckLabel;
	private NSTextField? greetingLabel;

	protected ViewController (NativeHandle handle) : base (handle)
	{
		// This constructor is required if the view controller is loaded from a xib or a storyboard.
		// Do not put any initialization here, use ViewDidLoad instead.
	}

	public override void ViewDidLoad ()
	{
		base.ViewDidLoad ();

		// Create stack view for vertical layout
		var stackView = new NSStackView {
			TranslatesAutoresizingMaskIntoConstraints = false,
			Orientation = NSUserInterfaceLayoutOrientation.Vertical,
			Spacing = 10,
			Alignment = NSLayoutAttribute.CenterX,
		};

		// Greeting label
		greetingLabel = new NSTextField {
			StringValue = "Welcome to MacSparkle!",
			Editable = false,
			Selectable = false,
			Bezeled = false,
			DrawsBackground = false,
			Alignment = NSTextAlignment.Center,
			TranslatesAutoresizingMaskIntoConstraints = false,
		};

		// Check for Updates button
		checkForUpdateButton = new NSButton {
			Title = "Check for Updates",
			BezelStyle = NSBezelStyle.Rounded,
			TranslatesAutoresizingMaskIntoConstraints = false,
		};
		checkForUpdateButton.Activated += OnCheckForUpdateClicked;

		// Automatic Updates checkbox
		automaticUpdatesCheckBox = new NSButton {
			Title = "Automatic Updates",
			TranslatesAutoresizingMaskIntoConstraints = false,
		};
		automaticUpdatesCheckBox.SetButtonType(NSButtonType.Switch);
		automaticUpdatesCheckBox.Activated += OnAutomaticUpdatesChanged;

		// Update Interval label
		updateIntervalLabel = new NSTextField {
			StringValue = "Update Interval: Loading...",
			Editable = false,
			Selectable = false,
			Bezeled = false,
			DrawsBackground = false,
			Alignment = NSTextAlignment.Center,
			TranslatesAutoresizingMaskIntoConstraints = false,
		};

		// Last Check label
		lastCheckLabel = new NSTextField {
			StringValue = "Last Check: Loading...",
			Editable = false,
			Selectable = false,
			Bezeled = false,
			DrawsBackground = false,
			Alignment = NSTextAlignment.Center,
			TranslatesAutoresizingMaskIntoConstraints = false,
		};

		// Add views to stack view
		stackView.AddArrangedSubview(greetingLabel);
		stackView.AddArrangedSubview(checkForUpdateButton);
		stackView.AddArrangedSubview(automaticUpdatesCheckBox);
		stackView.AddArrangedSubview(updateIntervalLabel);
		stackView.AddArrangedSubview(lastCheckLabel);

		View.AddSubview(stackView);

		// Center the stack view in the view
		stackView.CenterXAnchor.ConstraintEqualTo(View.CenterXAnchor).Active = true;
		stackView.CenterYAnchor.ConstraintEqualTo(View.CenterYAnchor).Active = true;
		stackView.LeadingAnchor.ConstraintGreaterThanOrEqualTo(View.LeadingAnchor, 20).Active = true;
		stackView.TrailingAnchor.ConstraintLessThanOrEqualTo(View.TrailingAnchor, -20).Active = true;

		// Load initial values
		LoadInitialValues();
	}

	private void LoadInitialValues()
	{
		try {
			var autoUpdatesEnabled = NativeMethods.mac_sparkle_get_automatic_check_for_updates() == 1;
			automaticUpdatesCheckBox?.State = autoUpdatesEnabled ? NSCellStateValue.On : NSCellStateValue.Off;

			var interval = NativeMethods.mac_sparkle_get_update_check_interval();
			updateIntervalLabel?.StringValue = $"Update Interval: {interval} seconds";

			var lastCheckTime = NativeMethods.mac_sparkle_get_last_check_time();
			if (lastCheckTime == -1) {
				lastCheckLabel?.StringValue = "Last Check: Never";
			} else {
				var lastCheckDate = NSDate.FromTimeIntervalSince1970(lastCheckTime);
				var formatter = new NSDateFormatter {
					DateStyle = NSDateFormatterStyle.Medium,
					TimeStyle = NSDateFormatterStyle.Short,
				};
				lastCheckLabel?.StringValue = $"Last Check: {formatter.ToString(lastCheckDate)}";
			}
		}
		catch {
			// Swallow interop errors for the demo.
		}
	}

	private void OnCheckForUpdateClicked (object? sender, EventArgs e)
	{
		try {
			NativeMethods.mac_sparkle_check_update_with_ui();
			// Refresh last check time after checking
			LoadInitialValues();
		}
		catch {
			// Swallow interop errors for the demo.
		}
	}

	private void OnAutomaticUpdatesChanged (object? sender, EventArgs e)
	{
		if (automaticUpdatesCheckBox != null) {
			try {
				var enabled = automaticUpdatesCheckBox.State == NSCellStateValue.On;
				NativeMethods.mac_sparkle_set_automatic_check_for_updates(enabled ? 1 : 0);
			}
			catch {
				// Swallow interop errors for the demo.
			}
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
