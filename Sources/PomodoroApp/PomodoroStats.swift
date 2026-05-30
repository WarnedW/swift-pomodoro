import Foundation

struct PomodoroStats: Codable, Equatable {
    var sessions: [FocusSession] = []

    var totalSessions: Int { sessions.count }
    var totalMinutes: Int { sessions.reduce(0) { $0 + $1.durationMinutes } }

    func sessions(on date: Date, calendar: Calendar = .current) -> [FocusSession] {
        sessions.filter { calendar.isDate($0.completedAt, inSameDayAs: date) }
    }

    func sessionsSince(_ date: Date) -> [FocusSession] {
        sessions.filter { $0.completedAt >= date }
    }

    func sessionsInCurrentWeek(referenceDate: Date = Date(), calendar: Calendar = .current) -> [FocusSession] {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: referenceDate) else { return [] }
        return sessions.filter { interval.contains($0.completedAt) }
    }

    func sessionsInCurrentMonth(referenceDate: Date = Date(), calendar: Calendar = .current) -> [FocusSession] {
        guard let interval = calendar.dateInterval(of: .month, for: referenceDate) else { return [] }
        return sessions.filter { interval.contains($0.completedAt) }
    }

    func bestDaySessionCount(calendar: Calendar = .current) -> Int {
        let grouped = Dictionary(grouping: sessions) { calendar.startOfDay(for: $0.completedAt) }
        return grouped.values.map(\.count).max() ?? 0
    }

    func bestDayMinutes(calendar: Calendar = .current) -> Int {
        let grouped = Dictionary(grouping: sessions) { calendar.startOfDay(for: $0.completedAt) }
        return grouped.values.map { daySessions in
            daySessions.reduce(0) { $0 + $1.durationMinutes }
        }.max() ?? 0
    }

    func activeDayCount(calendar: Calendar = .current) -> Int {
        Set(sessions.map { calendar.startOfDay(for: $0.completedAt) }).count
    }

    func sessionsCompleted(before hour: Int, calendar: Calendar = .current) -> Int {
        sessions.filter { calendar.component(.hour, from: $0.completedAt) < hour }.count
    }

    func sessionsCompleted(after hour: Int, calendar: Calendar = .current) -> Int {
        sessions.filter { calendar.component(.hour, from: $0.completedAt) >= hour }.count
    }

    func weekendSessionCount(calendar: Calendar = .current) -> Int {
        sessions.filter { session in
            calendar.isDateInWeekend(session.completedAt)
        }.count
    }

    func dailyReports(days: Int, referenceDate: Date = Date(), calendar: Calendar = .current) -> [DailyFocusReport] {
        let today = calendar.startOfDay(for: referenceDate)
        return (0..<days).reversed().map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today) ?? today
            let daySessions = sessions(on: date, calendar: calendar)
            return DailyFocusReport(
                date: date,
                sessions: daySessions.count,
                minutes: daySessions.reduce(0) { $0 + $1.durationMinutes }
            )
        }
    }

    func currentStreak(referenceDate: Date = Date(), calendar: Calendar = .current) -> Int {
        let today = calendar.startOfDay(for: referenceDate)
        let activeDays = Set(sessions.map { calendar.startOfDay(for: $0.completedAt) })
        guard !activeDays.isEmpty else { return 0 }

        var streak = 0
        var cursor = today

        while activeDays.contains(cursor) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = previousDay
        }

        return streak
    }
}
