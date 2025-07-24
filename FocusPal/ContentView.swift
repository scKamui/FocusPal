//
//  ContentView.swift
//  FocusPal
//
//  Created by Sami Chauhan
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @AppStorage("playSound") private var playSound = true
    @AppStorage("useDarkMode") private var useDarkMode = false
    @AppStorage("sessionHistory") private var sessionHistoryData = ""

    @State private var timeRemaining = 25 * 60
    @State private var totalTime = 25 * 60
    @State private var timerRunning = false
    @State private var timer: Timer? = nil
    @State private var startTime: Date?
    @State private var endTime: Date?
    @State private var isBreakTime = false
    @State private var showSessionComplete = false
    @State private var sessionCount = 0
    @State private var selectedQuote = ""

    let motivationalQuotes = [
        "Believe in yourself.",
        "Stay focused, stay sharp.",
        "Progress, not perfection.",
        "You're doing great!",
        "One step at a time."
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer().frame(height: 40)

                Text("FocusPal")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.primary)

                Text(isBreakTime ? "Break Time" : "Focus Time")
                    .font(.title2)
                    .foregroundColor(Color.primary)

                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 20)

                    Circle()
                        .trim(from: 0, to: CGFloat(Double(timeRemaining) / Double(totalTime)))
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut, value: timeRemaining)

                    Text(timeString(from: timeRemaining))
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(Color.primary)
                }
                .frame(width: 250, height: 250)

                Text("Sessions Completed: \(sessionCount)")
                    .foregroundColor(.secondary)

                HStack(spacing: 20) {
                    Button("Start", action: startTimer)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                    Button("Pause", action: pauseTimer)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                    Button("Reset", action: resetTimer)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .preferredColorScheme(useDarkMode ? .dark : .light)
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("")
            .navigationBarHidden(true)
            .alert(isPresented: $showSessionComplete) {
                Alert(
                    title: Text(isBreakTime ? "Break Over" : "Session Complete"),
                    message: Text(isBreakTime ? "Time to focus again!" : selectedQuote),
                    dismissButton: .default(Text("OK")) {
                        isBreakTime.toggle()
                        resetTimer()
                        startTimer()
                    }
                )
            }
        }
    }

    func startTimer() {
        if timerRunning { return }

        if timeRemaining == 25 * 60 || timeRemaining == 5 * 60 {
            totalTime = timeRemaining
        }

        startTime = Date()
        endTime = startTime?.addingTimeInterval(TimeInterval(timeRemaining))
        timerRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let end = endTime {
                let now = Date()
                timeRemaining = max(Int(end.timeIntervalSince(now)), 0)

                if timeRemaining == 0 {
                    timer?.invalidate()
                    timer = nil
                    timerRunning = false

                    if !isBreakTime {
                        sessionCount += 1
                        selectedQuote = motivationalQuotes.randomElement() ?? ""

                        let timestamp = DateFormatter.localizedString(
                            from: Date(),
                            dateStyle: .short,
                            timeStyle: .short
                        )
                        sessionHistoryData += "\(timestamp)|"
                    }

                    if playSound {
                        AudioServicesPlaySystemSound(1005)
                    }

                    showSessionComplete = true
                }
            }
        }
    }

    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false

        if let end = endTime {
            let now = Date()
            timeRemaining = max(Int(end.timeIntervalSince(now)), 0)
        }
    }

    func resetTimer() {
        pauseTimer()
        timeRemaining = isBreakTime ? 5 * 60 : 25 * 60
        totalTime = timeRemaining
        startTime = nil
        endTime = nil
    }

    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
