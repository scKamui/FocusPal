//
//  SettingsView.swift
//  FocusPal
//
//  Created by Sami Chauhan 
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("playSound") private var playSound = true
    @AppStorage("useDarkMode") private var useDarkMode = false

    var body: some View {
        NavigationView {
            Form {
                Toggle("Enable Sound", isOn: $playSound)
                Toggle("Dark Mode", isOn: $useDarkMode)
            }
            .navigationTitle("Settings")
        }
    }
}
