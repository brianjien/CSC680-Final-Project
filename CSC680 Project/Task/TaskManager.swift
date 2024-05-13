//
//  TaskManager.swift
//  CSC680 Final Project
//
//  Created by brianjien on 5/11/24.
//

import SwiftUI
class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    // 初始化时加载任务列表
    init() {
        loadTasks()
    }
    
    // 添加任务
    func addTask(task: Task) {
        tasks.append(task)
        saveTasks()
    }
    
    // 删除任务
    func deleteTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
            saveTasks()
        }
    }
    
    // 更新任务
    func updateTask(_ task: Task, with updatedTask: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = updatedTask
            saveTasks()
        }
    }
    
    // 保存任务列表到 UserDefaults
    private func saveTasks() {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: "tasks")
        }
    }
    
    // 从 UserDefaults 加载任务列表
    private func loadTasks() {
        if let tasksData = UserDefaults.standard.data(forKey: "tasks"),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: tasksData) {
            self.tasks = decodedTasks
        }
    }
}
