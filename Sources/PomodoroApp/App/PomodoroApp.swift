import AppKit
import SwiftUI

@main
struct PomodoroApp: App {
    @StateObject private var timer = PomodoroTimer()
    @Environment(\.openWindow) private var openWindow

    var body: some Scene {
        WindowGroup("Pomodoro", id: "main") {
            ContentView()
                .environmentObject(timer)
                .frame(minWidth: 500, idealWidth: 540, minHeight: 440, idealHeight: 480)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(after: .appInfo) {
                Button(timer.isRunning ? "Pause Timer" : "Start Timer") {
                    timer.toggle()
                }
                .keyboardShortcut(.space, modifiers: [])

                Button("Reset Timer") {
                    timer.resetCurrentMode()
                }
                .keyboardShortcut("r", modifiers: [.command])
            }
        }

        Settings {
            SettingsView()
                .environmentObject(timer)
                .frame(width: 420)
        }

        MenuBarExtra {
            Button {
                timer.toggle()
            } label: {
                Label(timer.isRunning ? "Pause" : "Start", systemImage: timer.isRunning ? "pause.fill" : "play.fill")
            }

            Button {
                timer.resetCurrentMode()
            } label: {
                Label("Reset", systemImage: "arrow.counterclockwise")
            }

            Button {
                timer.skip()
            } label: {
                Label("Skip", systemImage: "forward.end.fill")
            }

            Divider()

            Button {
                openWindow(id: "main")
                NSApp.activate(ignoringOtherApps: true)
            } label: {
                Label("Show Pomodoro", systemImage: "macwindow")
            }
        } label: {
            Text(timer.formattedRemainingTime)
                .monospacedDigit()
        }
        .menuBarExtraStyle(.menu)
    }
}
