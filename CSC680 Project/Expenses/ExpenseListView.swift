//
//  ExpenseListView.swift
//  CSC680 Final Project
//


import SwiftUI
struct ExpenseListView: View {
    @ObservedObject var expenseManager: ExpenseManager
    @State private var isExpenseEditorPresented = false
    @State private var selectedExpense: Expense?
    
    var body: some View {
        List {
            ForEach(expenseManager.expenses) { expense in
                Text("\(expense.amount)")
                    .onTapGesture {
                        selectedExpense = expense
                        isExpenseEditorPresented = true
                    }
            }
            .onDelete(perform: expenseManager.deleteExpense)
        }
        .navigationBarTitle("Expenses")
        .navigationBarItems(trailing:
            Button(action: {
                isExpenseEditorPresented = true
            }) {
                Image(systemName: "plus")
            }
        )
        .sheet(isPresented: $isExpenseEditorPresented) {
            ExpenseEditorView(expenseManager: expenseManager, expense: selectedExpense)
        }
    }
}
