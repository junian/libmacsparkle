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

        var btn = this.FindControl<Button>("CheckButton");
        if (btn != null)
        {
            btn.Click += OnCheckClicked;
        }
    }

    private void OnOpened(object? sender, EventArgs e)
    {
        try
        {
            NativeMethods.mac_sparkle_set_appcast_url("https://sparkle-project.org/files/sparkletestcast.xml");
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
}