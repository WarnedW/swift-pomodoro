import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var timer: PomodoroTimer

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText)
                Text("Tune your focus rhythm.")
                    .font(.callout)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            VStack(spacing: 12) {
                DurationControl(title: "Focus", value: $timer.settings.focusMinutes, range: 1...90)
                DurationControl(title: "Short break", value: $timer.settings.shortBreakMinutes, range: 1...30)
                DurationControl(title: "Long break", value: $timer.settings.longBreakMinutes, range: 1...60)
                DurationControl(title: "Long break after", value: $timer.settings.sessionsBeforeLongBreak, range: 2...8, unit: "sessions")
            }

            VStack(spacing: 14) {
                Toggle("Auto-start next round", isOn: $timer.settings.autoStartNextRound)
                Toggle("Play completion sound", isOn: $timer.settings.playSound)
            }
            .toggleStyle(.switch)
            .foregroundStyle(AppTheme.primaryText)
            .padding(18)
            .panel()

            Button(role: .destructive) {
                timer.resetStats()
            } label: {
                Label("Reset session history", systemImage: "trash")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(AppTheme.accent(for: .focus))
        }
        .contentPage(maxWidth: 560)
    }
}

private struct DurationControl: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    var unit = "min"

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.primaryText)
                Text("\(value) \(unit)")
                    .font(.callout.monospacedDigit())
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer()

            Stepper("", value: $value, in: range)
                .labelsHidden()
                .frame(width: 72)
        }
        .padding(18)
        .panel()
    }
}
