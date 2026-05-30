import Foundation

enum AchievementCatalog {
    static func achievements(for stats: PomodoroStats) -> [Achievement] {
        let weekSessions = stats.sessionsInCurrentWeek().count
        let monthSessions = stats.sessionsInCurrentMonth().count
        let streak = stats.currentStreak()
        let bestDaySessions = stats.bestDaySessionCount()
        let bestDayMinutes = stats.bestDayMinutes()
        let activeDays = stats.activeDayCount()
        let morningSessions = stats.sessionsCompleted(before: 10)
        let eveningSessions = stats.sessionsCompleted(after: 20)
        let weekendSessions = stats.weekendSessionCount()
        let totalSessions = stats.totalSessions
        let totalMinutes = stats.totalMinutes

        return [
            make(
                id: "first-focus",
                title: "First Focus",
                detail: "Complete 1 focus session",
                systemImage: "sparkle",
                current: totalSessions,
                target: 1
            ),
            make(
                id: "deep-start",
                title: "Deep Start",
                detail: "Complete 4 focus sessions",
                systemImage: "target",
                current: totalSessions,
                target: 4
            ),
            make(
                id: "ten-sessions",
                title: "Ten Sessions",
                detail: "Complete 10 focus sessions",
                systemImage: "10.circle",
                current: totalSessions,
                target: 10
            ),
            make(
                id: "twenty-five-sessions",
                title: "Quarter Century",
                detail: "Complete 25 focus sessions",
                systemImage: "25.circle",
                current: totalSessions,
                target: 25
            ),
            make(
                id: "hundred-sessions",
                title: "Century",
                detail: "Complete 100 focus sessions",
                systemImage: "100.circle",
                current: totalSessions,
                target: 100
            ),
            make(
                id: "two-fifty-sessions",
                title: "Momentum Engine",
                detail: "Complete 250 focus sessions",
                systemImage: "speedometer",
                current: totalSessions,
                target: 250
            ),
            make(
                id: "five-hundred-sessions",
                title: "Focus Architect",
                detail: "Complete 500 focus sessions",
                systemImage: "building.columns",
                current: totalSessions,
                target: 500
            ),
            make(
                id: "two-hours",
                title: "Two Focus Hours",
                detail: "Log 120 focused minutes",
                systemImage: "clock.badge.checkmark",
                current: totalMinutes,
                target: 120
            ),
            make(
                id: "ten-hours",
                title: "Ten Focus Hours",
                detail: "Log 600 focused minutes",
                systemImage: "hourglass",
                current: totalMinutes,
                target: 600
            ),
            make(
                id: "forty-hours",
                title: "Deep Work Week",
                detail: "Log 2,400 focused minutes",
                systemImage: "calendar.badge.clock",
                current: totalMinutes,
                target: 2_400
            ),
            make(
                id: "hundred-hours",
                title: "Hundred-Hour Mind",
                detail: "Log 6,000 focused minutes",
                systemImage: "brain.head.profile",
                current: totalMinutes,
                target: 6_000
            ),
            make(
                id: "strong-day",
                title: "Strong Day",
                detail: "Complete 6 sessions in one day",
                systemImage: "sun.max",
                current: bestDaySessions,
                target: 6
            ),
            make(
                id: "eight-session-day",
                title: "Eight in a Day",
                detail: "Complete 8 sessions in one day",
                systemImage: "bolt.circle",
                current: bestDaySessions,
                target: 8
            ),
            make(
                id: "four-hour-day",
                title: "Four-Hour Day",
                detail: "Log 240 minutes in one day",
                systemImage: "sun.max.circle",
                current: bestDayMinutes,
                target: 240
            ),
            make(
                id: "six-hour-day",
                title: "Six-Hour Summit",
                detail: "Log 360 minutes in one day",
                systemImage: "mountain.2",
                current: bestDayMinutes,
                target: 360
            ),
            make(
                id: "three-day-streak",
                title: "Three-Day Streak",
                detail: "Focus on 3 days in a row",
                systemImage: "flame",
                current: streak,
                target: 3
            ),
            make(
                id: "seven-day-streak",
                title: "Seven-Day Streak",
                detail: "Focus on 7 days in a row",
                systemImage: "flame.circle",
                current: streak,
                target: 7
            ),
            make(
                id: "fourteen-day-streak",
                title: "Fourteen-Day Streak",
                detail: "Focus on 14 days in a row",
                systemImage: "flame.fill",
                current: streak,
                target: 14
            ),
            make(
                id: "weekly-ten",
                title: "Weekly Ten",
                detail: "Complete 10 sessions this week",
                systemImage: "calendar",
                current: weekSessions,
                target: 10
            ),
            make(
                id: "weekly-twenty",
                title: "Weekly Sprint",
                detail: "Complete 20 sessions this week",
                systemImage: "calendar.badge.checkmark",
                current: weekSessions,
                target: 20
            ),
            make(
                id: "monthly-fifty",
                title: "Monthly Builder",
                detail: "Complete 50 sessions this month",
                systemImage: "square.grid.3x3",
                current: monthSessions,
                target: 50
            ),
            make(
                id: "monthly-hundred",
                title: "Monthly Master",
                detail: "Complete 100 sessions this month",
                systemImage: "crown",
                current: monthSessions,
                target: 100
            ),
            make(
                id: "monthly-one-fifty",
                title: "Monthly Elite",
                detail: "Complete 150 sessions this month",
                systemImage: "star.square",
                current: monthSessions,
                target: 150
            ),
            make(
                id: "ten-active-days",
                title: "Ten Active Days",
                detail: "Focus on 10 different days",
                systemImage: "calendar.day.timeline.left",
                current: activeDays,
                target: 10
            ),
            make(
                id: "thirty-active-days",
                title: "Thirty Active Days",
                detail: "Focus on 30 different days",
                systemImage: "calendar.circle",
                current: activeDays,
                target: 30
            ),
            make(
                id: "hundred-active-days",
                title: "Hundred Active Days",
                detail: "Focus on 100 different days",
                systemImage: "calendar.badge.plus",
                current: activeDays,
                target: 100
            ),
            make(
                id: "early-bird",
                title: "Early Bird",
                detail: "Complete 5 sessions before 10:00",
                systemImage: "sunrise",
                current: morningSessions,
                target: 5
            ),
            make(
                id: "morning-ritual",
                title: "Morning Ritual",
                detail: "Complete 25 sessions before 10:00",
                systemImage: "sunrise.circle",
                current: morningSessions,
                target: 25
            ),
            make(
                id: "night-shift",
                title: "Night Shift",
                detail: "Complete 5 sessions after 20:00",
                systemImage: "moon.stars",
                current: eveningSessions,
                target: 5
            ),
            make(
                id: "late-flow",
                title: "Late Flow",
                detail: "Complete 25 sessions after 20:00",
                systemImage: "moon.circle",
                current: eveningSessions,
                target: 25
            ),
            make(
                id: "weekend-spark",
                title: "Weekend Spark",
                detail: "Complete 5 sessions on weekends",
                systemImage: "sparkles",
                current: weekendSessions,
                target: 5
            ),
            make(
                id: "weekend-warrior",
                title: "Weekend Warrior",
                detail: "Complete 25 sessions on weekends",
                systemImage: "shield",
                current: weekendSessions,
                target: 25
            )
        ]
    }

    private static func make(
        id: String,
        title: String,
        detail: String,
        systemImage: String,
        current: Int,
        target: Int
    ) -> Achievement {
        Achievement(
            id: id,
            title: title,
            detail: detail,
            systemImage: systemImage,
            isUnlocked: current >= target,
            progress: min(1, Double(current) / Double(target))
        )
    }
}
