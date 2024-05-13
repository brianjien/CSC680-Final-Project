//
//  ExpenseManager.swift
//  CSC680 Final Project
//

import SwiftUI
class ExpenseManager: ObservableObject {
    @Published var expenses: [Expense] = []
    
    // 初始化时加载已保存的费用列表
    init() {
        loadExpenses()
    }
    
    // 添加费用
    func addExpense(expense: Expense) {
        expenses.append(expense)
        saveExpenses()
    }
    
    // 删除费用
    func deleteExpense(at index: Int) {
        expenses.remove(at: index)
        saveExpenses()
    }
    
    // 更新费用
    func updateExpense(at index: Int, with expense: Expense) {
        expenses[index] = expense
        saveExpenses()
    }
    
    // 保存费用列表到 UserDefaults
    func saveExpenses() {
        if let encodedData = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encodedData, forKey: "expenses")
        }
    }
    
    // 从 UserDefaults 加载费用列表
    private func loadExpenses() {
        if let expensesData = UserDefaults.standard.data(forKey: "expenses"),
           let decodedExpenses = try? JSONDecoder().decode([Expense].self, from: expensesData) {
            self.expenses = decodedExpenses
        }
    }
}

