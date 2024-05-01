import SwiftUI

// MARK: - Models

struct Task: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var description: String
    var frequency: String
    var assignedTo: String
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Expense: Identifiable, Equatable {
    var id = UUID()
    var amount: Double
    var category: String
    var contributors: [String]
    var date: Date
    
    static func == (lhs: Expense, rhs: Expense) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Notice: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var content: String
    var postedBy: String
    var date: Date
    
    static func == (lhs: Notice, rhs: Notice) -> Bool {
        return lhs.id == rhs.id
    }
}

struct User {
    var username: String
    var password: String
    var role: UserRole
}

enum UserRole {
    case admin
    case regular
}

// MARK: - Task Manager

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    
    // sample tasks
    init() {
        self.tasks = [
            Task(title: "Clean the kitchen", description: "Wipe down all countertops and appliances", frequency: "Daily", assignedTo: "John"),
            Task(title: "Take out the trash", description: "Empty all trash cans and replace with new bags", frequency: "Daily", assignedTo: "Mary"),
            Task(title: "Vacuum the living room", description: "Vacuum carpets and rugs", frequency: "Weekly", assignedTo: "Alice")
        ]
    }
    
    func addTask(task: Task) {
        tasks.append(task)
    }
    
    func deleteTask(at indexSet: IndexSet) {
        tasks.remove(atOffsets: indexSet)
    }
    
    func updateTask(at index: Int, with task: Task) {
        tasks[index] = task
    }
}

// MARK: - Expense Manager

class ExpenseManager: ObservableObject {
    @Published var expenses: [Expense] = []
    
    // sample expenses
    init() {
        self.expenses = [
            Expense(amount: 20.0, category: "Groceries", contributors: ["John", "Mary"], date: Date()),
            Expense(amount: 30.0, category: "Utilities", contributors: ["Alice"], date: Date())
        ]
    }
    
    func addExpense(expense: Expense) {
        expenses.append(expense)
    }
    
    func deleteExpense(at indexSet: IndexSet) {
        expenses.remove(atOffsets: indexSet)
    }
    
    func updateExpense(at index: Int, with expense: Expense) {
        expenses[index] = expense
    }
}

// MARK: - Notice Manager

class NoticeManager: ObservableObject {
    @Published var notices: [Notice] = []
    
    // sample notices
    init() {
        self.notices = [
            Notice(title: "Important Announcement", content: "Please remember to clean up after yourselves in the kitchen!", postedBy: "Admin", date: Date()),
            Notice(title: "Upcoming Event", content: "Our monthly house meeting will be held this Saturday at 10 AM.", postedBy: "Admin", date: Date())
        ]
    }
    
    func addNotice(notice: Notice) {
        notices.append(notice)
    }
    
    func deleteNotice(at indexSet: IndexSet) {
        notices.remove(atOffsets: indexSet)
    }
    
    func updateNotice(at index: Int, with notice: Notice) {
        notices[index] = notice
    }
}

// MARK: - User Manager
// MARK: - User Manager
class UserManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    // Maintain a list of registered users
    var registeredUsers: [User] = []
    
    init() {
        // sample admin user
        let adminUser = User(username: "admin", password: "admin", role: .admin)
        registeredUsers.append(adminUser)
    }
    
    func login(username: String, password: String) {
        if let user = registeredUsers.first(where: { $0.username == username && $0.password == password }) {
            isLoggedIn = true
            currentUser = user
        } else {
            print("Invalid username or password")
        }
    }
    
    func logout() {
        isLoggedIn = false
        currentUser = nil
    }
    
    func register(username: String, password: String) {
        if registeredUsers.contains(where: { $0.username == username }) {
            print("Username already exists. Please choose a different username.")
            return
        }
        let newUser = User(username: username, password: password, role: .regular)
        registeredUsers.append(newUser)
        print("Registration successful. You can now login with your credentials.")
        print("Registered users: \(registeredUsers)")
    }
}

// MARK: - ContentView - Main User Interface
struct ContentView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var navigateToRegistration: Bool = false
    @State private var isLoggedIn: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoggedIn {
                    NavigationLink(destination: TaskListView(taskManager: TaskManager())) {
                        Text("Tasks")
                            .padding()
                    }
                    NavigationLink(destination: ExpenseListView(expenseManager: ExpenseManager())) {
                        Text("Expenses")
                            .padding()
                    }
                    NavigationLink(destination: NoticeListView(noticeManager: NoticeManager())) {
                        Text("Notices")
                            .padding()
                    }
                    Button("Logout") {
                        userManager.logout()
                        isLoggedIn = false
                    }
                    .padding()
                } else {
                    if navigateToRegistration {
                        RegistrationView(navigateToRegistration: $navigateToRegistration)
                    } else {
                        LoginView(navigateToRegistration: $navigateToRegistration)
                            .padding()
                    }
                }
            }
            .onReceive(userManager.$isLoggedIn) { loggedIn in
                if loggedIn {
                    navigateToRegistration = false
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("Chore Assigner App")
        }
    }
}


// MARK: - Login View
struct LoginView: View {
    @EnvironmentObject var userManager: UserManager
    @Binding var navigateToRegistration: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Login")
            // Username input
            TextField("Enter username", text: $username)
                .padding()
                .frame(maxWidth: .infinity)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(.black).opacity(0.1))
                )
            // Password input
            SecureField("Enter password", text: $password)
                .padding()
                .frame(maxWidth: .infinity)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(.black).opacity(0.1))
                )
            // Login button
            Button(action: login) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 372, height: 33)
                    .background(Color.black)
                    .cornerRadius(8)
            }
            // Cancel button
            Button(action: {}) {
                Text("Cancel")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 372, height: 33)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 0.50)
                    )
            }
            // Sign up link
            Text("Need an account? Sign up here!")
                .underline()
                .foregroundColor(.black)
                .onTapGesture {
                    navigateToRegistration = true
                }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
        .frame(width: 382, height: 483)
        .background(Color.white)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func login() {
        if username.isEmpty || password.isEmpty {
            showAlert = true
            alertMessage = "Please enter a username and password."
            return
        }
        userManager.login(username: username, password: password)
    }
}


// MARK: - Registration View
struct RegistrationView: View {
    @EnvironmentObject var userManager: UserManager
    @Binding var navigateToRegistration: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack{
            Text("   Registration")
            VStack{
                TextField("Enter username", text: $username)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(
                                Color(.black).opacity(0.10)
                            )
                    )
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            VStack {
                SecureField("Enter password", text: $password)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(
                                Color(.black).opacity(0.10)
                            )
                    )
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            VStack{
                SecureField("Confirm password", text: $confirmPassword)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(
                                Color(.black).opacity(0.10)
                            )
                    )
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            
            Button(action: register) {
                Text("Register")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 372, height: 33)
                    .background(.black)
                    .cornerRadius(8)
            }
            
            Button(action: {
                self.navigateToRegistration = false
            }) {
                Text("Cancel")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 372, height: 33)
                    .background(.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.black, lineWidth: 0.50)
                    )
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func register() {
        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showAlert = true
            alertMessage = "Please enter a username, password, and confirm password."
            return
        }
        
        if password != confirmPassword {
            showAlert = true
            alertMessage = "Passwords do not match. Please enter the same password in both fields."
            return
        }
        
        userManager.register(username: username, password: password)
        navigateToRegistration = false
    }
}


// MARK: - Admin Dashboard View

struct AdminDashboardView: View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var expenseManager: ExpenseManager
    @EnvironmentObject var noticeManager: NoticeManager
    
    @State private var isTaskEditorPresented = false
    @State private var isExpenseEditorPresented = false
    @State private var isNoticeEditorPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button("View Tasks") {
                    isTaskEditorPresented = true
                }
                .padding()
                .sheet(isPresented: $isTaskEditorPresented) {
                    TaskListView(taskManager: taskManager)
                }
                
                Button("View Expenses") {
                    isExpenseEditorPresented = true
                }
                .padding()
                .sheet(isPresented: $isExpenseEditorPresented) {
                    ExpenseListView(expenseManager: expenseManager)
                }
                
                Button("View Notices") {
                    isNoticeEditorPresented = true
                }
                .padding()
                .sheet(isPresented: $isNoticeEditorPresented) {
                    NoticeListView(noticeManager: noticeManager)
                }
                
                Spacer()
            }
            .navigationBarTitle("Admin Dashboard")
        }
    }
}

// MARK: - Regular User Dashboard View

struct RegularUserDashboardView: View {
    @EnvironmentObject var noticeManager: NoticeManager
    
    var body: some View {
        NavigationView {
            VStack {
                Button("View Notices") {
                    //
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitle("User Dashboard")
        }
    }
}

// MARK: - TaskListView - Display Tasks

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
                .onDelete(perform: taskManager.deleteTask)
            }
            .navigationBarTitle("Tasks")
            .navigationBarItems(trailing:
                Button(action: {
                    isTaskEditorPresented = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $isTaskEditorPresented) {
                TaskEditorView(taskManager: taskManager, task: selectedTask)
            }
        }
    }
}


// MARK: - ExpenseListView - Display Expenses

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

// MARK: - NoticeListView - Display Notices

struct NoticeListView: View {
    @ObservedObject var noticeManager: NoticeManager
    @State private var isNoticeEditorPresented = false
    @State private var selectedNotice: Notice?
    
    var body: some View {
        List {
            ForEach(noticeManager.notices) { notice in
                Text(notice.title)
                    .onTapGesture {
                        selectedNotice = notice
                        isNoticeEditorPresented = true
                    }
            }
            .onDelete(perform: noticeManager.deleteNotice)
        }
        .navigationBarTitle("Notices")
        .navigationBarItems(trailing:
            Button(action: {
                isNoticeEditorPresented=true
            }) {
                Image(systemName: "plus")
            }
        )
        .sheet(isPresented: $isNoticeEditorPresented) {
            NoticeEditorView(noticeManager: noticeManager, notice: selectedNotice)
        }
    }
}

// MARK: - Task Editor View

struct TaskEditorView: View {
    @ObservedObject var taskManager: TaskManager
    var task: Task?
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var frequency: String = ""
    @State private var assignedTo: String = ""
    
    var body: some View {
        Form {
            TextField("Title", text: $title)
            TextField("Description", text: $description)
            TextField("Frequency", text: $frequency)
            TextField("Assigned To", text: $assignedTo)
        }
        .onAppear {
            if let task = task {
                title = task.title
                description = task.description
                frequency = task.frequency
                assignedTo = task.assignedTo
            }
        }
        .navigationBarTitle(task != nil ? "Edit Task" : "Add Task")
        .navigationBarItems(trailing:
            Button("Save") {
                let updatedTask = Task(title: title, description: description, frequency: frequency, assignedTo: assignedTo)
                if let task = task {
                    taskManager.updateTask(at: taskManager.tasks.firstIndex(of: task)!, with: updatedTask)
                } else {
                    taskManager.addTask(task: updatedTask)
                }
            }
        )
    }
}

// MARK: - Expense Editor View

struct ExpenseEditorView: View {
    @ObservedObject var expenseManager: ExpenseManager
    var expense: Expense?
    
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var contributors: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        Form {
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
            TextField("Category", text: $category)
            TextField("Contributors", text: $contributors)
            DatePicker("Date", selection: $date, displayedComponents: .date)
        }
        .onAppear {
            if let expense = expense {
                amount = "\(expense.amount)"
                category = expense.category
                contributors = expense.contributors.joined(separator: ", ")
                date = expense.date
            }
        }
        .navigationBarTitle(expense != nil ? "Edit Expense" : "Add Expense")
        .navigationBarItems(trailing:
            Button("Save") {
                let contributorsArray = contributors.components(separatedBy: ",")
                let updatedExpense = Expense(amount: Double(amount) ?? 0.0, category: category, contributors: contributorsArray, date: date)
                if let expense = expense {
                    expenseManager.updateExpense(at: expenseManager.expenses.firstIndex(of: expense)!, with: updatedExpense)
                } else {
                    expenseManager.addExpense(expense: updatedExpense)
                }
            }
        )
    }
}

// MARK: - Notice Editor View

struct NoticeEditorView: View {
    @ObservedObject var noticeManager: NoticeManager
    var notice: Notice?
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var postedBy: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        Form {
            TextField("Title", text: $title)
            TextField("Content", text: $content)
            TextField("Posted By", text: $postedBy)
            DatePicker("Date", selection: $date, displayedComponents: .date)
        }
        .onAppear {
            if let notice = notice {
                title = notice.title
                content = notice.content
                postedBy = notice.postedBy
                date = notice.date
            }
        }
        .navigationBarTitle(notice != nil ? "Edit Notice" : "Add Notice")
        .navigationBarItems(trailing:
            Button("Save") {
                let updatedNotice = Notice(title: title, content: content, postedBy: postedBy, date: date)
                if let notice = notice {
                    noticeManager.updateNotice(at: noticeManager.notices.firstIndex(of: notice)!, with: updatedNotice)
                } else {
                    noticeManager.addNotice(notice: updatedNotice)
                }
            }
        )
    }
}
