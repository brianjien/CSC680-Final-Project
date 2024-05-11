

import SwiftUI




struct TaskEditorView: View {
    @ObservedObject var taskManager: TaskManager
    @Binding var task: Task?
    let onSave: (Task) -> Void

    @State private var editedTask: Task

    init(taskManager: TaskManager, task: Binding<Task?>, onSave: @escaping (Task) -> Void) {
        self.taskManager = taskManager
        self._task = task
        self._editedTask = State(initialValue: task.wrappedValue ?? Task(title: "", description: "", frequency: "", assignedTo: ""))
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $editedTask.title)
                    TextField("Description", text: $editedTask.description)
                    TextField("Frequency", text: $editedTask.frequency)
                    TextField("Assigned To", text: $editedTask.assignedTo)
                }
            }
            .navigationBarTitle(task != nil ? "Edit Task" : "New Task")
            .navigationBarItems(trailing:
                Button("Save") {
                    onSave(editedTask)
                }
            )
        }
    }
}
