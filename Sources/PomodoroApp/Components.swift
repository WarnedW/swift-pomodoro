import SwiftUI

enum AppTheme {
    static let background = LinearGradient(
        colors: [
            Color(red: 0.12, green: 0.13, blue: 0.13),
            Color(red: 0.10, green: 0.12, blue: 0.12)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let panel = Color(red: 0.15, green: 0.17, blue: 0.17)
    static let selectedPanel = Color(red: 0.18, green: 0.22, blue: 0.21)
    static let panelStroke = Color.white.opacity(0.08)
    static let primaryText = Color(red: 0.90, green: 0.91, blue: 0.92)
    static let secondaryText = Color(red: 0.58, green: 0.61, blue: 0.62)
    static let quietFill = Color(red: 0.13, green: 0.24, blue: 0.22)
    static let controlFill = Color(red: 0.12, green: 0.25, blue: 0.22)

    static func accent(for mode: PomodoroMode) -> Color {
        switch mode {
        case .focus: Color(red: 0.12, green: 0.58, blue: 0.50)
        case .shortBreak: Color(red: 0.16, green: 0.63, blue: 0.54)
        case .longBreak: Color(red: 0.28, green: 0.52, blue: 0.85)
        }
    }
}

struct TimerRing: View {
    let progress: Double
    let label: String
    let mode: PomodoroMode

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.quietFill, lineWidth: 12)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AppTheme.accent(for: mode),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.25), value: progress)

            VStack(spacing: 10) {
                Image(systemName: mode.systemImage)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(AppTheme.accent(for: mode))

                Text(label)
                    .font(.system(size: 74, weight: .light, design: .rounded))
                    .monospacedDigit()
                    .minimumScaleFactor(0.7)
                    .foregroundStyle(AppTheme.primaryText)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(mode.title), \(label) remaining")
    }
}

struct PanelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.panel, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(AppTheme.panelStroke)
            }
            .shadow(color: Color.black.opacity(0.18), radius: 18, y: 10)
    }
}

extension View {
    func panel() -> some View {
        modifier(PanelStyle())
    }

    func contentPage(maxWidth: CGFloat = 620) -> some View {
        ScrollView {
            self
                .frame(maxWidth: maxWidth, alignment: .leading)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 28)
                .padding(.top, 28)
                .padding(.bottom, 34)
        }
    }
}

struct ModePicker: View {
    let selectedMode: PomodoroMode
    let onSelect: (PomodoroMode) -> Void

    var body: some View {
        Picker("Mode", selection: Binding(get: {
            selectedMode
        }, set: { mode in
            onSelect(mode)
        })) {
            ForEach(PomodoroMode.allCases) { mode in
                Label(mode.title, systemImage: mode.systemImage)
                    .tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .frame(width: 260)
    }
}
