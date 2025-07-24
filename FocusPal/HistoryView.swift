//
//  HistoryView.swift
//  FocusPal
//
//  Created by Sami Chauhan 
//

import SwiftUI

struct HistoryView: View {
    @AppStorage("sessionHistory") var sessionHistoryData: String = ""

    var sessionHistory: [String] {
        sessionHistoryData.components(separatedBy: "|").filter { !$0.isEmpty }
    }

    var body: some View {
        NavigationView {
            VStack {
                if sessionHistory.isEmpty {
                    Text("No sessions yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(sessionHistory.reversed(), id: \.self) { entry in
                            Text(entry)
                        }
                    }
                }

                Button(action: {
                    sessionHistoryData = ""
                }) {
                    Text("Clear History")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding([.horizontal, .bottom])
                }
                .disabled(sessionHistory.isEmpty)
            }
            .navigationTitle("Session History")
        }
    }
}
