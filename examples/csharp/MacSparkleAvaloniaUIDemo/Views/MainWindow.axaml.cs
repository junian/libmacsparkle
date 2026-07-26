using Avalonia.Controls;
using Avalonia.Interactivity;
using System;

namespace MacSparkleDemo.Views;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();

        this.Opened += OnOpened;
        this.Closed += OnClosed;

        var btn = this.FindControl<Button>("CheckButton");
        if (btn != null)
        {
            btn.Click += OnCheckClicked;
        }
    }

    private void OnOpened(object? sender, EventArgs e)
    {
        // Configure Sparkle on app load
        try
        {
            NativeMethods.mac_sparkle_set_appcast_url("https://example.com/appcast.xml");
            NativeMethods.mac_sparkle_set_eddsa_public_key("test-public-key");
            NativeMethods.mac_sparkle_set_app_details("Example Company", "Example App", "1.2.3");
            NativeMethods.mac_sparkle_init();
        }
        catch
        {
            // Swallow interop errors for the demo
        }
    }

    private void OnCheckClicked(object? sender, RoutedEventArgs e)
    {
        try
        {
            NativeMethods.mac_sparkle_check_update_with_ui();
        }
        catch
        {
        }
    }

    private void OnClosed(object? sender, EventArgs e)
    {
        try
        {
            NativeMethods.mac_sparkle_cleanup();
        }
        catch
        {
        }
    }
}