using Avalonia.Controls;
using Avalonia.Interactivity;
using MacSparkleDemo.ViewModels;

namespace MacSparkleDemo.Views;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();

        var btn = this.FindControl<Button>("CheckButton");
        if (btn != null)
        {
            btn.Click += OnCheckClicked;
        }

        var autoUpdateCheckBox = this.FindControl<CheckBox>("AutoUpdateCheckBox");
        if (autoUpdateCheckBox != null)
        {
            autoUpdateCheckBox.Click += OnAutoUpdateClicked;
        }

        this.Opened += OnOpened;
    }

    private void OnOpened(object? sender, System.EventArgs e)
    {
        if (DataContext is not MainWindowViewModel viewModel) return;
        var autoUpdateCheckBox = this.FindControl<CheckBox>("AutoUpdateCheckBox");
        if (autoUpdateCheckBox != null)
        {
            autoUpdateCheckBox.IsChecked = viewModel.GetAutomaticUpdatesEnabled();
        }

        UpdateStatusDisplay(viewModel);
    }

    private void OnCheckClicked(object? sender, RoutedEventArgs e)
    {
        if (DataContext is not MainWindowViewModel viewModel) return;
        viewModel.CheckForUpdates();
        UpdateStatusDisplay(viewModel);
    }

    private void OnAutoUpdateClicked(object? sender, RoutedEventArgs e)
    {
        if (DataContext is not MainWindowViewModel viewModel) return;
        var checkBox = sender as CheckBox;
        if (checkBox == null) return;
        viewModel.SetAutomaticUpdates(checkBox.IsChecked ?? false);
        UpdateStatusDisplay(viewModel);
    }

    private void UpdateStatusDisplay(MainWindowViewModel viewModel)
    {
        var updateIntervalText = this.FindControl<TextBlock>("UpdateIntervalText");
        if (updateIntervalText != null)
        {
            var interval = viewModel.GetUpdateCheckInterval();
            updateIntervalText.Text = $"Update Interval: {interval} seconds";
        }

        var lastCheckText = this.FindControl<TextBlock>("LastCheckText");
        if (lastCheckText == null) return;
        var lastCheckTime = viewModel.GetLastCheckTime();
        if (lastCheckTime == -1)
        {
            lastCheckText.Text = "Last Check: Never";
        }
        else
        {
            var lastCheckDate = System.DateTimeOffset.FromUnixTimeSeconds(lastCheckTime);
            lastCheckText.Text = $"Last Check: {lastCheckDate.LocalDateTime}";
        }
    }
}