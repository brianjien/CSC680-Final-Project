//
//  MemoListView.swift
//  CSC680 Project
//
//  Created by brianjien on 5/13/24.
//
import SwiftUI
// MARK: - MemoListView

struct MemoListView: View {
    @ObservedObject var memoManager: MemoManager
    @State private var isMemoEditorPresented = false
    @State private var selectedMemo: Memo?
    
    var body: some View {
        List {
            ForEach(memoManager.memos) { memo in
                Text(memo.title)
                    .onTapGesture {
                        selectedMemo = memo
                        isMemoEditorPresented = true
                    }
            }
            .onDelete(perform: memoManager.deleteMemo)
        }
        .navigationBarTitle("Memos")
        .navigationBarItems(trailing:
                                Button(action: {
            isMemoEditorPresented=true
        }) {
            Image(systemName: "plus")
        }
        )
        .sheet(isPresented: $isMemoEditorPresented) {
            MemoEditorView(memoManager: memoManager, memo: selectedMemo)
        }
    }
}
