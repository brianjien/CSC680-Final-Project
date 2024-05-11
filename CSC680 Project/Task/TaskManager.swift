//
//  TaskManager.swift
//  CSC680 Final Project
//
//  Created by brianjien on 5/11/24.
//

import SwiftUI

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    
    // sample tasks
    init() {
        self.tasks = [
            Task(title: "Clean the kitchen", description: "Wipe down all countertops and appliances", frequency: "Daily", assignedTo: "John"),
            Task(title: "Take out the trash", description: "Empty all trash cans and replace with new bags", frequency: "Daily", assignedTo: "Mary"),
            Task(title: "Vacuum the living room", description: "Vacuum carpets and rugs", frequency: "Weekly", assignedTo: "Alice")
        ]
    }
    
    func addTask(task: Task) {
        tasks.append(task)
    }
    
    func deleteTask(at indexSet: IndexSet) {
        tasks.remove(atOffsets: indexSet)
    }
    
    func updateTask(at index: Int, with task: Task) {
        tasks[index] = task
    }
}

