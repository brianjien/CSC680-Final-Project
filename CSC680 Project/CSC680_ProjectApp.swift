//
//  CSC680_ProjectApp.swift
//  CSC680 Project
//
//  Created by brianjien on 5/11/24.
//

import SwiftUI

@main
struct CSC680_ProjectApp: App {
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
