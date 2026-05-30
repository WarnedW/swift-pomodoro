import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject private var timer: PomodoroTimer

    private var achievements: [Achievement] {
        AchievementCatalog.achievements(for: timer.stats)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Achievements")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText)
                Text("Milestones unlock automatically as sessions build up.")
                    .font(.callout)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(achievements) { achievement in
                    AchievementTile(achievement: achievement)
                }
            }
        }
        .contentPage(maxWidth: 680)
    }
}

private struct AchievementTile: View {
    let achievement: Achievement

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: achievement.systemImage)
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(achievement.isUnlocked ? AppTheme.accent(for: .focus) : AppTheme.secondaryText)
                .frame(width: 34, height: 34)

            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.primaryText)
                Text(achievement.detail)
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            ProgressView(value: achievement.progress)
                .tint(achievement.isUnlocked ? AppTheme.accent(for: .focus) : AppTheme.secondaryText)

            Text(achievement.isUnlocked ? "Unlocked" : "\(Int(achievement.progress * 100))%")
                .font(.caption.weight(.medium))
                .foregroundStyle(achievement.isUnlocked ? AppTheme.accent(for: .focus) : AppTheme.secondaryText)
        }
        .frame(minHeight: 156, alignment: .topLeading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .panel()
        .opacity(achievement.isUnlocked ? 1 : 0.62)
    }
}
