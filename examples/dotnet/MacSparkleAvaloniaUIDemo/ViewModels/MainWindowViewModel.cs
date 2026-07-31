using System;
using Avalonia.Threading;
using CommunityToolkit.Mvvm.ComponentModel;
using MacSparkle;

namespace MacSparkleDemo.ViewModels;

public partial class MainWindowViewModel : ViewModelBase
{
    [ObservableProperty]
    private bool _automaticUpdatesEnabled;

    [ObservableProperty]
    private int _updateCheckInterval;

    [ObservableProperty]
    private long _lastCheckTime;

    [ObservableProperty]
    private string _updateIntervalText = "Loading...";

    [ObservableProperty]
    private string _lastCheckText = "Loading...";

    [ObservableProperty]
    private string _httpHeaderName = "Authorization";

    [ObservableProperty]
    private string _httpHeaderValue = "Bearer your-token-here";

    [ObservableProperty]
    private string _errorMessageText = "No errors reported";

    private NativeMethods.MacSparkleErrorCallback? _errorCallback;

    public string Greeting { get; } = "Welcome to Avalonia!";

    public MainWindowViewModel()
    {
        InitializeSparkle();
    }

    private void InitializeSparkle()
    {
        try
        {
            NativeMethods.mac_sparkle_set_appcast_url("https://sparkle-project.org/files/sparkletestcast.xml");

            // Set an example HTTP header before initializing
            NativeMethods.mac_sparkle_set_http_header("X-Example-Header", "libMacSparkle-demo");

            // Register an error callback that marshals back to the UI thread
            _errorCallback = OnSparkleError;
            NativeMethods.mac_sparkle_set_error_callback(_errorCallback);

            NativeMethods.mac_sparkle_init();

            // Configure automatic updates
            NativeMethods.mac_sparkle_set_automatic_check_for_updates(1);

            // Set update check interval to 1 hour (3600 seconds)
            NativeMethods.mac_sparkle_set_update_check_interval(3600);

            // Load initial values
            AutomaticUpdatesEnabled = GetAutomaticUpdatesEnabled();
            UpdateCheckInterval = GetUpdateCheckInterval();
            LastCheckTime = GetLastCheckTime();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to initialize Sparkle: {ex.Message}");
        }
    }

    private void OnSparkleError()
    {
        Dispatcher.UIThread.Post(() => ErrorMessageText = $"Sparkle error occurred at {DateTime.Now}");
    }

    public void CheckForUpdates()
    {
        try
        {
            NativeMethods.mac_sparkle_check_update_with_ui();
            // Refresh last check time after checking
            LastCheckTime = GetLastCheckTime();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to check for updates: {ex.Message}");
        }
    }

    public void CheckForUpdatesWithoutUI()
    {
        try
        {
            NativeMethods.mac_sparkle_check_update_without_ui();
            LastCheckTime = GetLastCheckTime();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to check for updates in background: {ex.Message}");
        }
    }

    public void SetHttpHeader()
    {
        try
        {
            NativeMethods.mac_sparkle_set_http_header(HttpHeaderName, HttpHeaderValue);
            Console.WriteLine($"Set HTTP header '{HttpHeaderName}'");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to set HTTP header: {ex.Message}");
        }
    }

    public void ClearHttpHeaders()
    {
        try
        {
            NativeMethods.mac_sparkle_clear_http_headers();
            Console.WriteLine("Cleared HTTP headers");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to clear HTTP headers: {ex.Message}");
        }
    }

    partial void OnAutomaticUpdatesEnabledChanged(bool value)
    {
        SetAutomaticUpdates(value);
    }

    partial void OnUpdateCheckIntervalChanged(int value)
    {
        UpdateIntervalText = $"Update Interval: {value} seconds";
        SetUpdateCheckInterval(value);
    }

    partial void OnLastCheckTimeChanged(long value)
    {
        LastCheckText = value == -1 ? "Last Check: Never" : $"Last Check: {DateTimeOffset.FromUnixTimeSeconds(value).LocalDateTime}";
    }

    public bool GetAutomaticUpdatesEnabled()
    {
        try
        {
            return NativeMethods.mac_sparkle_get_automatic_check_for_updates() == 1;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to get automatic updates state: {ex.Message}");
            return false;
        }
    }

    public void SetAutomaticUpdates(bool enabled)
    {
        try
        {
            NativeMethods.mac_sparkle_set_automatic_check_for_updates(enabled ? 1 : 0);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to set automatic updates: {ex.Message}");
        }
    }

    public int GetUpdateCheckInterval()
    {
        try
        {
            return NativeMethods.mac_sparkle_get_update_check_interval();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to get update interval: {ex.Message}");
            return 86400; // Default 24 hours
        }
    }

    private void SetUpdateCheckInterval(int seconds)
    {
        try
        {
            NativeMethods.mac_sparkle_set_update_check_interval(seconds);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to set update interval: {ex.Message}");
        }
    }

    public long GetLastCheckTime()
    {
        try
        {
            return NativeMethods.mac_sparkle_get_last_check_time();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to get last check time: {ex.Message}");
            return -1;
        }
    }
}
