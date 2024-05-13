import SwiftUI
class ExpenseManager: ObservableObject {
    @Published var expenses: [Expense] = []
    
    init() {
        loadExpenses()
    }
    
    func addExpense(expense: Expense) {
        expenses.append(expense)
        saveExpenses()
    }
    
    func deleteExpense(at index: Int) {
        expenses.remove(at: index)
        saveExpenses()
    }
    
    func updateExpense(at index: Int, with expense: Expense) {
        expenses[index] = expense
        saveExpenses()
    }
    
    func saveExpenses() {
        if let encodedData = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encodedData, forKey: "expenses")
        }
    }
    
    private func loadExpenses() {
        if let expensesData = UserDefaults.standard.data(forKey: "expenses"),
           let decodedExpenses = try? JSONDecoder().decode([Expense].self, from: expensesData) {
            self.expenses = decodedExpenses
        }
    }
}

