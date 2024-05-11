//
//  ExpenseManager.swift
//  CSC680 Final Project
//
<<<<<<< HEAD
//  Created by brianjien on 5/11/24.
=======
//  Created by Hsin Yu Chen on 5/11/24.
>>>>>>> 057177fce9911a81046546483607ed6f1c05b428
//

import SwiftUI
class ExpenseManager: ObservableObject {
    @Published var expenses: [Expense] = []
    
    // sample expenses
    init() {
        self.expenses = [
            Expense(amount: 20.0, category: "Groceries", contributors: ["John", "Mary"], date: Date()),
            Expense(amount: 30.0, category: "Utilities", contributors: ["Alice"], date: Date())
        ]
    }
    
    func addExpense(expense: Expense) {
        expenses.append(expense)
    }
    
    func deleteExpense(at indexSet: IndexSet) {
        expenses.remove(atOffsets: indexSet)
    }
    
    func updateExpense(at index: Int, with expense: Expense) {
        expenses[index] = expense
    }
}
