import SwiftUI
import Foundation

class ExpenseManager: ObservableObject {
    @Published var expenses: [Expense] = []
    
    func addExpense(expense: Expense) {
        expenses.append(expense)
    }
    
    func updateExpense(at index: Int, with expense: Expense) {
        guard index >= 0 && index < expenses.count else {
            return
        }
        expenses[index] = expense
    }
    
    func deleteExpense(at index: Int) {
        guard index >= 0 && index < expenses.count else {
            return
        }
        expenses.remove(at: index)
    }
    
    func saveExpenses() {
        do {
            // Encode latitude and longitude separately
            let encodedExpenses = expenses.map { expense in
                return Expense(id: expense.id,
                               amount: expense.amount,
                               category: expense.category,
                               contributors: expense.contributors,
                               date: expense.date,
                               isSettled: expense.isSettled,
                               latitude: expense.latitude,
                               longitude: expense.longitude)
            }
            let data = try PropertyListEncoder().encode(encodedExpenses)
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("expenses.plist")
            try data.write(to: url)
        } catch {
            print("Error saving expenses: \(error)")
        }
    }

}
