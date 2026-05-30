import AppKit

protocol PomodoroFeedback {
    func sessionDidComplete(settings: PomodoroSettings)
}

struct SystemPomodoroFeedback: PomodoroFeedback {
    func sessionDidComplete(settings: PomodoroSettings) {
        guard settings.playSound else { return }
        NSSound(named: "Glass")?.play()
    }
}
