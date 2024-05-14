import SwiftUI
class MemoManager: ObservableObject {
    @Published var memos: [Memo] = []
    
    init() {
        self.memos = [
            Memo(title: "Shopping List", content: "Buy groceries", date: Date(), checklistItems: [
                ChecklistItem(title: "Milk", isChecked: false),
                ChecklistItem(title: "Eggs", isChecked: true),
                ChecklistItem(title: "Bread", isChecked: false)
            ]),
            Memo(title: "Meeting Notes", content: "Discuss project timeline", date: Date(), checklistItems: [
                ChecklistItem(title: "Agenda 1", isChecked: true),
                ChecklistItem(title: "Agenda 2", isChecked: false),
                ChecklistItem(title: "Agenda 3", isChecked: false)
            ])
        ]
    }
    
    func addMemo(memo: Memo) {
        memos.append(memo)
    }
    
    func deleteMemo(at indexSet: IndexSet) {
        memos.remove(atOffsets: indexSet)
    }
    
    func updateMemo(at index: Int, with memo: Memo) {
        memos[index] = memo
    }
}
