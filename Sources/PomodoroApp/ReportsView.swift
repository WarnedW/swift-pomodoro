import SwiftUI

struct ReportsView: View {
    @EnvironmentObject private var timer: PomodoroTimer

    private var weekReports: [DailyFocusReport] {
        timer.stats.dailyReports(days: 7)
    }

    private var weekSessions: Int {
        weekReports.reduce(0) { $0 + $1.sessions }
    }

    private var weekMinutes: Int {
        weekReports.reduce(0) { $0 + $1.minutes }
    }

    private var todayMinutes: Int {
        timer.stats.sessions(on: Date()).reduce(0) { $0 + $1.durationMinutes }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Reports")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText)
                Text("A clear look at your recent focus rhythm.")
                    .font(.callout)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ReportMetric(title: "Today", value: "\(timer.stats.sessions(on: Date()).count)", detail: "\(todayMinutes) min")
                ReportMetric(title: "This week", value: "\(weekSessions)", detail: "\(weekMinutes) min")
                ReportMetric(title: "Total", value: "\(timer.stats.totalSessions)", detail: "\(timer.stats.totalMinutes) min")
                ReportMetric(title: "Streak", value: "\(timer.stats.currentStreak())", detail: "days")
            }

            VStack(alignment: .leading, spacing: 14) {
                Text("Last 7 days")
                    .font(.headline)
                    .foregroundStyle(AppTheme.primaryText)

                HStack(alignment: .bottom, spacing: 10) {
                    ForEach(weekReports) { report in
                        DailyBar(report: report, maxSessions: max(1, weekReports.map(\.sessions).max() ?? 1))
                    }
                }
                .frame(height: 170)
            }
            .padding(18)
            .panel()
        }
        .contentPage(maxWidth: 680)
    }
}

private struct ReportMetric: View {
    let title: String
    let value: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.callout)
                .foregroundStyle(AppTheme.secondaryText)
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(value)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(AppTheme.primaryText)
                Text(detail)
                    .font(.callout)
                    .foregroundStyle(AppTheme.secondaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .panel()
    }
}

private struct DailyBar: View {
    let report: DailyFocusReport
    let maxSessions: Int

    private var weekday: String {
        report.date.formatted(.dateTime.weekday(.narrow))
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("\(report.sessions)")
                .font(.caption.monospacedDigit())
                .foregroundStyle(AppTheme.secondaryText)

            GeometryReader { proxy in
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(report.sessions == 0 ? AppTheme.quietFill : AppTheme.accent(for: .focus))
                        .frame(height: max(8, proxy.size.height * CGFloat(report.sessions) / CGFloat(maxSessions)))
                }
            }

            Text(weekday)
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }
}
