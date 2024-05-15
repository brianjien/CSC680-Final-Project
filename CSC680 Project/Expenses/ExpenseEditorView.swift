import SwiftUI
struct ExpenseEditorView: View {
    @ObservedObject var expenseManager: ExpenseManager
    @Binding var isPresented: Bool
    
    var expense: Expense?
    
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var contributors: String = ""
    @State private var date: Date = Date()
    @State private var isSettled: Bool = false
    @State private var isSaving: Bool = false
    
    var body: some View {
        Form {
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
            TextField("Category", text: $category)
            TextField("Contributors", text: $contributors)
            DatePicker("Date", selection: $date, displayedComponents: .date)
            Toggle("Settled", isOn: $isSettled)
            
            Button(action: {
                isSaving = true
                saveExpense()
            }) {
                Text("Save")
            }
            .disabled(isSaving)
        }
        .onAppear {
            if let expense = expense {
                amount = "\(expense.amount)"
                category = expense.category
                contributors = expense.contributors.joined(separator: ", ")
                date = expense.date
                isSettled = expense.isSettled
            }
        }
        .navigationBarTitle(expense != nil ? "Edit Expense" : "Add Expense")
    }
    
    private func saveExpense() {
        let contributorsArray = contributors.components(separatedBy: ",")
        let updatedExpense = Expense(amount: Double(amount) ?? 0.0, category: category, contributors: contributorsArray, date: date, isSettled: isSettled)
        if let expense = expense {
            expenseManager.updateExpense(at: expenseManager.expenses.firstIndex(of: expense)!, with: updatedExpense)
        } else {
            expenseManager.addExpense(expense: updatedExpense)
        }
        
        expenseManager.saveExpenses()
        
        isSaving = false
        isPresented = false // 在保存後關閉編輯頁面
    }
}



struct ExpenseRow: View {
    var expense: Expense
    var onEdit: () -> Void // 添加 onEdit 闭包
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Amount: \(expense.amount)")
                    .font(.headline)
                Text("Category: \(expense.category)")
                    .font(.subheadline)
                Text("Contributors: \(expense.contributors.joined(separator: ", "))")
                    .font(.subheadline)
                Text("Date: \(expense.date, formatter: dateFormatter)")
                    .font(.subheadline)
            }
            .padding(.vertical)
            
            Spacer()
            
            Button(action: {
                onEdit() // 点击编辑按钮时调用 onEdit 闭包
            }) {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.blue)
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}
