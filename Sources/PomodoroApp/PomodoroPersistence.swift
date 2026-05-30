import Foundation

protocol PomodoroPersistence {
    func loadSettings() -> PomodoroSettings
    func saveSettings(_ settings: PomodoroSettings)
    func loadStats() -> PomodoroStats
    func saveStats(_ stats: PomodoroStats)
}

struct UserDefaultsPomodoroPersistence: PomodoroPersistence {
    private let userDefaults: UserDefaults
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadSettings() -> PomodoroSettings {
        load(PomodoroSettings.self, forKey: StorageKey.settings) ?? PomodoroSettings()
    }

    func saveSettings(_ settings: PomodoroSettings) {
        save(settings, forKey: StorageKey.settings)
    }

    func loadStats() -> PomodoroStats {
        load(PomodoroStats.self, forKey: StorageKey.stats) ?? PomodoroStats()
    }

    func saveStats(_ stats: PomodoroStats) {
        save(stats, forKey: StorageKey.stats)
    }

    private func load<Value: Decodable>(_ type: Value.Type, forKey key: String) -> Value? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? decoder.decode(type, from: data)
    }

    private func save<Value: Encodable>(_ value: Value, forKey key: String) {
        guard let data = try? encoder.encode(value) else { return }
        userDefaults.set(data, forKey: key)
    }
}

private enum StorageKey {
    static let settings = "pomodoro.settings.v1"
    static let stats = "pomodoro.stats.v1"
}
