//
//  ExpenseListView.swift
//  CSC680 Final Project
//
<<<<<<< HEAD
//  Created by brianjien on 5/11/24.
=======
//  Created by Hsin Yu Chen on 5/11/24.
>>>>>>> 057177fce9911a81046546483607ed6f1c05b428
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
