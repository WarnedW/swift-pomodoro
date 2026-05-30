import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var timer: PomodoroTimer
    @State private var selectedView = MainView.timer

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .frame(height: 48)

                switch selectedView {
                case .timer:
                    timerView
                case .reports:
                    ReportsView()
                case .achievements:
                    AchievementsView()
                case .settings:
                    SettingsView()
                }
            }
        }
    }

    private var topBar: some View {
        HStack(spacing: 16) {
            Spacer()

            Button {
                selectedView = .reports
            } label: {
                Image(systemName: "chart.bar")
                    .font(.system(size: 28, weight: .regular))
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
            .foregroundStyle(selectedView == .reports ? AppTheme.accent(for: timer.mode) : AppTheme.primaryText)
            .help("Reports")

            Menu {
                Button("Timer") { selectedView = .timer }
                Button("Achievements") { selectedView = .achievements }
                Button("Settings") { selectedView = .settings }
                Button("Reset timer") { timer.resetCurrentMode() }
                Divider()
                ForEach(PomodoroMode.allCases) { mode in
                    Button(mode.title) {
                        timer.selectMode(mode)
                        selectedView = .timer
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 28, weight: .regular))
                    .rotationEffect(.degrees(90))
                    .frame(width: 36, height: 36)
            }
            .menuStyle(.borderlessButton)
            .foregroundStyle(AppTheme.primaryText)
            .help("More")
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    private var timerView: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 16)

            Text(timer.mode == .focus ? "Flow" : timer.mode.title)
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.primaryText)

            Text(timer.formattedRemainingTime)
                .font(.system(size: 96, weight: .light, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.6)
                .foregroundStyle(AppTheme.primaryText)
                .padding(.top, 12)

            focusDots
                .padding(.top, 4)

            Button {
                timer.toggle()
            } label: {
                Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                    .font(.system(size: 34, weight: .medium))
                    .frame(width: 78, height: 78)
                    .background(AppTheme.controlFill, in: Circle())
            }
            .buttonStyle(.plain)
            .foregroundStyle(AppTheme.accent(for: timer.mode))
            .keyboardShortcut(.space, modifiers: [])
            .padding(.top, 34)

            HStack(spacing: 22) {
                Button {
                    timer.skip()
                } label: {
                    Label("Skip", systemImage: "forward.end.fill")
                        .labelStyle(.iconOnly)
                }
                .help("Skip")

                Button {
                    selectedView = .achievements
                } label: {
                    Label("Achievements", systemImage: "rosette")
                        .labelStyle(.iconOnly)
                }
                .help("Achievements")
            }
            .buttonStyle(.plain)
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(AppTheme.secondaryText)
            .padding(.top, 20)

            Spacer()
        }
        .padding(.horizontal, 44)
    }

    private var focusDots: some View {
        HStack(spacing: 10) {
            ForEach(0..<timer.settings.longBreakCadence, id: \.self) { index in
                Circle()
                    .fill(index < timer.completedFocusSessions % timer.settings.longBreakCadence ? AppTheme.accent(for: .focus) : AppTheme.quietFill)
                    .frame(width: 18, height: 18)
            }
        }
    }
}

private enum MainView: String, CaseIterable, Identifiable {
    case timer
    case reports
    case achievements
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .timer: "Timer"
        case .reports: "Reports"
        case .achievements: "Achievements"
        case .settings: "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .timer: "timer"
        case .reports: "chart.bar"
        case .achievements: "rosette"
        case .settings: "slider.horizontal.3"
        }
    }
}
