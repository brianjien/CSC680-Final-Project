// MARK: - Memo Editor View
import SwiftUI
struct MemoEditorView: View {
    @ObservedObject var memoManager: MemoManager
    var memo: Memo?
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var date: Date = Date()
    @State private var checklistItems: [ChecklistItem] = []
    
    var body: some View {
        Form {
            Section(header: Text("Memo Details")) {
                TextField("Title", text: $title)
                TextField("Content", text: $content)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            
            Section(header: Text("Checklist")) {
                ForEach(checklistItems.indices, id: \.self) { index in
                    ChecklistItemRow(checklistItem: $checklistItems[index])
                }
                
                Button(action: {
                    checklistItems.append(ChecklistItem(title: "", isChecked: false))
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Item")
                    }
                }
            }
        }
        .onAppear {
            if let memo = memo {
                title = memo.title
                content = memo.content
                date = memo.date
                checklistItems = memo.checklistItems
            }
        }
        .navigationBarTitle(memo != nil ? "Edit Memo" : "Add Memo")
        .navigationBarItems(trailing:
                                Button("Save") {
            let updatedMemo = Memo(title: title, content: content, date: date, checklistItems: checklistItems)
            if let memo = memo {
                memoManager.updateMemo(at: memoManager.memos.firstIndex(of: memo)!, with: updatedMemo)
            } else {
                memoManager.addMemo(memo: updatedMemo)
            }
        }
        )
    }
}

struct ChecklistItemRow: View {
    @Binding var checklistItem: ChecklistItem
    
    var body: some View {
        HStack {
            TextField("Checklist Item", text: $checklistItem.title)
            Spacer()
            Image(systemName: checklistItem.isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundColor(checklistItem.isChecked ? .green : .gray)
                .onTapGesture {
                    checklistItem.isChecked.toggle()
                }
        }
    }
}
