using System;
using Avalonia.Controls;
using Avalonia.Interactivity;
using MacSparkleDemo.ViewModels;

namespace MacSparkleDemo.Views;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();

        WireUpButton("CheckButton", OnCheckClicked);
        WireUpButton("CheckBackgroundButton", OnCheckBackgroundClicked);
        WireUpButton("SetHeaderButton", OnSetHeaderClicked);
        WireUpButton("ClearHeadersButton", OnClearHeadersClicked);

        var autoUpdateCheckBox = this.FindControl<CheckBox>("AutoUpdateCheckBox");
        if (autoUpdateCheckBox != null)
        {
            autoUpdateCheckBox.Click += OnAutoUpdateClicked;
        }

        this.Opened += OnOpened;
    }

    private void WireUpButton(string name, EventHandler<RoutedEventArgs> handler)
    {
        var button = this.FindControl<Button>(name);
        if (button != null)
        {
            button.Click += handler;
        }
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

    private void OnCheckBackgroundClicked(object? sender, RoutedEventArgs e)
    {
        if (DataContext is not MainWindowViewModel viewModel) return;
        viewModel.CheckForUpdatesWithoutUI();
        UpdateStatusDisplay(viewModel);
    }

    private void OnSetHeaderClicked(object? sender, RoutedEventArgs e)
    {
        if (DataContext is not MainWindowViewModel viewModel) return;
        viewModel.SetHttpHeader();
    }

    private void OnClearHeadersClicked(object? sender, RoutedEventArgs e)
    {
        if (DataContext is not MainWindowViewModel viewModel) return;
        viewModel.ClearHttpHeaders();
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
