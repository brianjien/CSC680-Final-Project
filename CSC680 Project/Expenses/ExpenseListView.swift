//
//  ExpenseListView.swift
//  CSC680 Final Project
//


import SwiftUI
struct ExpenseListView: View {
    @ObservedObject var expenseManager: ExpenseManager
    @State private var isExpenseEditorPresented = false
    @State private var selectedExpense: Expense?
    @State private var sortBy: SortType = .contributor // 添加排序方式
    @State private var showSettled = false // 添加用於控制是否顯示已結算費用的狀態屬性
    
    enum SortType {
        case contributor
        case date
        case amount
    }
    
    var body: some View {
        NavigationView {
            List {
                // 未結算的費用列表
                Section(header: Text("Unsettled Expenses")) {
                    ForEach(sortedExpenses.filter { !$0.isSettled }) { expense in
                        ExpenseRow(expense: expense) {
                            selectedExpense = expense
                            isExpenseEditorPresented = true
                        }
                    }
                }
                
                // 已結算的費用列表
                if showSettled {
                    Section(header: Text("Settled Expenses")) {
                        ForEach(sortedExpenses.filter { $0.isSettled }) { expense in
                            ExpenseRow(expense: expense) {
                                selectedExpense = expense
                                isExpenseEditorPresented = true
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Expenses")
            .navigationBarItems(leading: Picker(selection: $sortBy, label: Text("Sort by")) {
                Text("Contributor").tag(SortType.contributor)
                Text("Date").tag(SortType.date)
                Text("Amount").tag(SortType.amount)
            }
            .pickerStyle(SegmentedPickerStyle()),
            trailing: Button(action: {
                isExpenseEditorPresented = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isExpenseEditorPresented) {
                ExpenseEditorView(expenseManager: expenseManager, isPresented: $isExpenseEditorPresented, expense: selectedExpense)
            }
        }
    }
    
    var sortedExpenses: [Expense] {
        switch sortBy {
        case .contributor:
            return expenseManager.expenses.sorted { $0.contributors.joined(separator: ", ") < $1.contributors.joined(separator: ", ") }
        case .date:
            return expenseManager.expenses.sorted { $0.date < $1.date }
        case .amount:
            return expenseManager.expenses.sorted { $0.amount < $1.amount }
        }
    }
}


