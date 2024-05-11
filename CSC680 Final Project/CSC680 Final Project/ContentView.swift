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
class UserManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    // Maintain a list of registered users
    var registeredUsers: [User] = []
    
    init() {
        // sample admin user
        let adminUser = User(username: "", password: "", role: .admin)
        registeredUsers.append(adminUser)
    }
    
    func login(username: String, password: String) {
        if let user = registeredUsers.first(where: { $0.username == username && $0.password == password }) {
            print("Pass")
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
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.horizontal)
                    }
                    NavigationLink(destination: ExpenseListView(expenseManager: ExpenseManager())) {
                        Text("Expenses")
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    NavigationLink(destination: NoticeListView(noticeManager: NoticeManager())) {
                        Text("Notices")
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    Button("Logout") {
                        userManager.logout()
                        isLoggedIn = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    TabView {
                        NavigationBar()
                    }
                    .frame(height: 70)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .padding([.leading, .trailing])
                    .shadow(radius: 5)
                    .padding(.bottom, 8)
                } else {
                    if navigateToRegistration {
                        RegistrationView(navigateToRegistration: $navigateToRegistration)
                    } else {
                        LoginView(navigateToRegistration: $navigateToRegistration, onLoginSuccess: {
                            self.isLoggedIn = true
                        })
                        .padding()
                    }
                }
                
                Spacer()
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


struct NavigationBar: View {
    @State private var selectedTab: Tab = .home

    enum Tab {
        case home, chores, schedule, settings
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Spacer()
            NavigationBarItem(imageName: "house.fill", title: "Home", tab: .home, isSelected: selectedTab == .home, action: {
                selectedTab = .home
            })
            Spacer()
            NavigationBarItem(imageName: "list.bullet", title: "Chores", tab: .chores, isSelected: selectedTab == .chores, action: {
                selectedTab = .chores
            })
            Spacer()
            NavigationLink(destination: CalendarView(), isActive: Binding.constant(selectedTab == .schedule)) {
                NavigationBarItem(imageName: "calendar", title: "Calendar", tab: .schedule, isSelected: selectedTab == .schedule, action: {
                    selectedTab = .schedule
                })
            }
            Spacer()
            
            NavigationBarItem(imageName: "gear", title: "Settings", tab: .settings, isSelected: selectedTab == .settings, action: {
                selectedTab = .settings
            })
            Spacer()
        }
        .padding(.top, 68)
        .padding(.bottom, 12)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 0.50)
                .stroke(Color(red: 0.96, green: 0.94, blue: 0.90), lineWidth: 0.50)
        )
    }
}

 

struct NavigationBarItem: View {
    let imageName: String
    let title: String
    let tab: NavigationBar.Tab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: imageName)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? Color(red: 0.11, green: 0.09, blue: 0.05) : Color(red: 0.64, green: 0.51, blue: 0.29))
                Text(title)
                    .font(Font.custom("Lexend", size: 12).weight(.medium))
                    .lineSpacing(16)
                    .foregroundColor(isSelected ? Color(red: 0.11, green: 0.09, blue: 0.05) : Color(red: 0.64, green: 0.51, blue: 0.29))
            }
            .frame(maxWidth: .infinity, minHeight: 59, maxHeight: 69)
            .background(isSelected ? Color(red: 0.96, green: 0.94, blue: 0.90) : Color.clear) // Highlight selected tab
            .cornerRadius(8)
        }
        .padding(.horizontal, 8)
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

#Preview{
    ContentView()
        .environmentObject(UserManager())
}
