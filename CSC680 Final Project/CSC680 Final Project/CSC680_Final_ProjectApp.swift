//
//  CSC680_Final_ProjectApp.swift
//  CSC680 Final Project
//
//  Created by brianjien on 3/12/24.
//

import SwiftUI
@main
struct CSC680_Final_ProjectApp: App {
    @StateObject private var userManager = UserManager()
    @StateObject private var taskManager = TaskManager()
    @StateObject private var expenseManager = ExpenseManager()
    @StateObject private var noticeManager = NoticeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager)
                .environmentObject(taskManager)
                .environmentObject(expenseManager)
                .environmentObject(noticeManager)
        }
    }
}
