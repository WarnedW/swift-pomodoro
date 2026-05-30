import Foundation

enum PomodoroMode: String, CaseIterable, Identifiable {
    case focus = "Focus"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .focus: "Focus"
        case .shortBreak: "Short break"
        case .longBreak: "Long break"
        }
    }

    var systemImage: String {
        switch self {
        case .focus: "target"
        case .shortBreak: "cup.and.saucer"
        case .longBreak: "leaf"
        }
    }
}

struct PomodoroSettings: Codable, Equatable {
    var focusMinutes = 25
    var shortBreakMinutes = 5
    var longBreakMinutes = 15
    var sessionsBeforeLongBreak = 4
    var autoStartNextRound = false
    var playSound = true

    var longBreakCadence: Int {
        max(1, sessionsBeforeLongBreak)
    }

    func duration(for mode: PomodoroMode) -> Int {
        let minutes = switch mode {
        case .focus: focusMinutes
        case .shortBreak: shortBreakMinutes
        case .longBreak: longBreakMinutes
        }

        return max(1, minutes) * 60
    }
}

struct FocusSession: Codable, Identifiable, Equatable {
    let id: UUID
    let completedAt: Date
    let durationMinutes: Int

    init(id: UUID = UUID(), completedAt: Date = Date(), durationMinutes: Int) {
        self.id = id
        self.completedAt = completedAt
        self.durationMinutes = durationMinutes
    }
}

struct DailyFocusReport: Identifiable, Equatable {
    let date: Date
    let sessions: Int
    let minutes: Int

    var id: Date { date }
}

struct Achievement: Identifiable, Equatable {
    let id: String
    let title: String
    let detail: String
    let systemImage: String
    let isUnlocked: Bool
    let progress: Double
}
