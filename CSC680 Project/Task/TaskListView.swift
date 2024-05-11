import SwiftUI
struct TaskListView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var isTaskEditorPresented = false
    @State private var selectedTask: Task?

    var body: some View {
        NavigationView {
            List {
                ForEach(taskManager.tasks) { task in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(task.title)
                            .font(Font.custom("Roboto", size: 16))
                            .foregroundColor(.black)
                        Text(task.description)
                            .font(Font.custom("Roboto", size: 14))
                            .foregroundColor(Color(red: 0, green: 0, blue: 0).opacity(0.50))
                    }
                    .onTapGesture {
                        selectedTask = task
                        isTaskEditorPresented = true
                    }
                }
                .onDelete(perform: deleteTask)
            }
            .navigationBarTitle("Tasks")
            .navigationBarItems(trailing:
                Button(action: {
                    // Create a new task
                    selectedTask = nil // Set selectedTask to nil to indicate new task
                    isTaskEditorPresented = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $isTaskEditorPresented) {
                TaskEditorView(taskManager: taskManager, task: $selectedTask) { task in
                    if selectedTask != nil {
                        // Editing existing task
                        if let index = taskManager.tasks.firstIndex(where: { $0.id == task.id }) {
                            taskManager.tasks[index] = task
                        }
                    } else {
                        // Adding new task
                        taskManager.addTask(task: task)
                    }
                    // Dismiss the sheet
                    isTaskEditorPresented = false
                }
            }
        }
    }

    func deleteTask(at offsets: IndexSet) {
        taskManager.deleteTask(at: offsets)
    }
}
