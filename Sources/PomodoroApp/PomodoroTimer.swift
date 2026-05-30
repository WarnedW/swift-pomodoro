import Combine
import Foundation

@MainActor
final class PomodoroTimer: ObservableObject {
    @Published var settings: PomodoroSettings {
        didSet {
            guard settings != oldValue else { return }
            persistence.saveSettings(settings)
            if !isRunning {
                remainingSeconds = settings.duration(for: mode)
            } else if settings.duration(for: mode) < remainingSeconds {
                remainingSeconds = settings.duration(for: mode)
            }
        }
    }

    @Published private(set) var mode: PomodoroMode = .focus
    @Published private(set) var remainingSeconds: Int
    @Published private(set) var completedFocusSessions = 0
    @Published private(set) var isRunning = false
    @Published private(set) var stats: PomodoroStats

    private var currentModeDuration: Int
    private let persistence: PomodoroPersistence
    private let feedback: PomodoroFeedback
    private let ticker: PomodoroTicker
    private let calendar: Calendar
    private let now: () -> Date

    init(
        persistence: PomodoroPersistence = UserDefaultsPomodoroPersistence(),
        feedback: PomodoroFeedback = SystemPomodoroFeedback(),
        ticker: PomodoroTicker = FoundationPomodoroTicker(),
        calendar: Calendar = .current,
        now: @escaping () -> Date = Date.init
    ) {
        let savedSettings = persistence.loadSettings()
        let duration = savedSettings.duration(for: .focus)
        let savedStats = persistence.loadStats()
        self.persistence = persistence
        self.feedback = feedback
        self.ticker = ticker
        self.calendar = calendar
        self.now = now
        settings = savedSettings
        remainingSeconds = duration
        currentModeDuration = duration
        stats = savedStats
        completedFocusSessions = savedStats.sessions(on: now(), calendar: calendar).count
    }

    var progress: Double {
        guard currentModeDuration > 0 else { return 0 }
        return 1 - (Double(remainingSeconds) / Double(currentModeDuration))
    }

    var formattedRemainingTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var nextModeDescription: String {
        schedule.nextModeDescription(currentMode: mode, completedFocusSessions: completedFocusSessions)
    }

    private var schedule: PomodoroSchedule {
        PomodoroSchedule(settings: settings)
    }

    func toggle() {
        isRunning ? pause() : start()
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        scheduleTimer()
    }

    func pause() {
        isRunning = false
        ticker.stop()
    }

    func resetCurrentMode() {
        pause()
        configure(mode, resetRemaining: true)
    }

    func skip() {
        completeCurrentMode()
    }

    func selectMode(_ newMode: PomodoroMode) {
        pause()
        configure(newMode, resetRemaining: true)
    }

    func resetStats() {
        completedFocusSessions = 0
        stats = PomodoroStats()
        persistence.saveStats(stats)
    }

    private func scheduleTimer() {
        ticker.start { [weak self] in
            self?.tick()
        }
    }

    private func tick() {
        guard remainingSeconds > 0 else {
            completeCurrentMode()
            return
        }

        remainingSeconds -= 1

        if remainingSeconds == 0 {
            completeCurrentMode()
        }
    }

    private func completeCurrentMode() {
        if mode == .focus {
            completedFocusSessions += 1
            stats.sessions.append(FocusSession(completedAt: now(), durationMinutes: settings.focusMinutes))
            persistence.saveStats(stats)
        }

        feedback.sessionDidComplete(settings: settings)

        let nextMode = schedule.nextMode(after: mode, completedFocusSessions: completedFocusSessions)
        configure(nextMode, resetRemaining: true)

        if settings.autoStartNextRound {
            start()
        } else {
            pause()
        }
    }

    private func configure(_ newMode: PomodoroMode, resetRemaining: Bool) {
        mode = newMode
        currentModeDuration = settings.duration(for: newMode)
        if resetRemaining {
            remainingSeconds = currentModeDuration
        }
    }
}
