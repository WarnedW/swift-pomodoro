import Foundation

struct PomodoroSchedule {
    let settings: PomodoroSettings

    func nextMode(after completedMode: PomodoroMode, completedFocusSessions: Int) -> PomodoroMode {
        switch completedMode {
        case .focus:
            return completedFocusSessions.isMultiple(of: settings.longBreakCadence) ? .longBreak : .shortBreak
        case .shortBreak, .longBreak:
            return .focus
        }
    }

    func nextModeDescription(currentMode: PomodoroMode, completedFocusSessions: Int) -> String {
        switch currentMode {
        case .focus:
            let nextFocusCount = completedFocusSessions + 1
            return nextFocusCount.isMultiple(of: settings.longBreakCadence) ? "Long break next" : "Short break next"
        case .shortBreak, .longBreak:
            return "Focus next"
        }
    }
}
