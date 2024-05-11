//
//  SettingView.swift
//  CSC680 Final Project
//
//  Created by brianjien on 5/11/24.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    NavigationLink(destination: AccountSettingsView()) {
                        Text("Account Settings")
                    }
               
                    NavigationLink(destination: NotificationSettingsView()) {
                        Text("Notification Settings")
                    }
                }
                
                Section(header: Text("General")) {
             
                    NavigationLink(destination: LanguageSettingsView()) {
                        Text("Language Settings")
                    }
                    NavigationLink(destination: AppearanceSettingsView()) {
                        Text("Appearance Settings")
                    }
                }
                
                Section(header: Text("About")) {
                    NavigationLink(destination: AboutAppView()) {
                        Text("About App")
                    }
                 
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Setting")
            
        }
    }
}



#Preview {
    SettingView()
}
