import Foundation

@MainActor
protocol PomodoroTicker: AnyObject {
    func start(_ onTick: @escaping @MainActor () -> Void)
    func stop()
}

@MainActor
final class FoundationPomodoroTicker: PomodoroTicker {
    private var timer: Timer?

    func start(_ onTick: @escaping @MainActor () -> Void) {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            Task { @MainActor in
                onTick()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
