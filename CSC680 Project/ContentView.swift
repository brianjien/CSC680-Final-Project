import SwiftUI

// MARK: - Models

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var frequency: String
    var assignedTo: String
}
enum TaskStatus {
    case pending
    case inProgress
    case completed
}


struct Expense: Identifiable, Equatable, Codable {
    var id = UUID()
    var amount: Double
    var category: String
    var contributors: [String]
    var date: Date
    var isSettled: Bool
}



// MARK: - Memo Model
struct Memo: Identifiable, Equatable, Codable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
    var checklistItems: [ChecklistItem] // New property for checklist items
    
    static func == (lhs: Memo, rhs: Memo) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ChecklistItem: Identifiable, Equatable, Codable {
    var id = UUID()
    var title: String
    var isChecked: Bool
}

struct User: Codable {
    var username: String
    var password: String
    var role: UserRole
}

enum UserRole: String, Codable {
    case admin
    case regular
}

enum Tab {
    case home
    case chores
    case schedule
    case settings
}





// MARK: - User Manager
class UserManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    var registeredUsers: [User] = []
    
    init() {
        // Load registered users from UserDefaults on initialization
        loadRegisteredUsers()
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
        // Registration logic...
        let newUser = User(username: username, password: password, role: .regular)
        registeredUsers.append(newUser)
        saveRegisteredUsers() // Save registered users after adding a new user
    }
    
    // Function to save registered users to UserDefaults
    private func saveRegisteredUsers() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(registeredUsers) {
            UserDefaults.standard.set(encodedData, forKey: "registeredUsers")
        }
    }
    
    // Function to load registered users from UserDefaults
    private func loadRegisteredUsers() {
        if let userData = UserDefaults.standard.data(forKey: "registeredUsers") {
            let decoder = JSONDecoder()
            if let decodedUsers = try? decoder.decode([User].self, from: userData) {
                registeredUsers = decodedUsers
            }
        }
    }
}



// MARK: - ContentView - Main User Interface
struct ContentView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var navigateToRegistration: Bool = false
    @State private var isLoggedIn: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoading: Bool = false
    // Create a single instance of TaskManager
    @StateObject var taskManager = TaskManager()

    var body: some View {
        NavigationView {
            VStack {
                if isLoggedIn {
                    TabView {
                        TaskListView(taskManager: taskManager) // Pass the same instance of TaskManager to each view
                            .tabItem {
                                Label("Tasks", systemImage: "list.bullet")
                            }
                        
                        ExpenseListView(expenseManager: ExpenseManager())
                            .tabItem {
                                Label("Expenses", systemImage: "square.and.pencil")
                            }
                        
                        MemoListView(memoManager: MemoManager())
                            .tabItem {
                                Label("Memos", systemImage: "note.text")
                            }
                        ChoresAssignerView(taskManager: taskManager) // Pass the same instance of TaskManager
                            .tabItem {
                                Label("Chores Assigner", systemImage: "wand.and.stars")
                            }
                    }
                    .padding(.bottom, 8)
                    .edgesIgnoringSafeArea(.bottom)
                    .background(Color.white)
                    .accentColor(.purple)
                    
                } else {
                    if navigateToRegistration {
                        RegistrationView(navigateToRegistration: $navigateToRegistration)
                            .navigationBarHidden(true)
                    } else {
                        LoginView(navigateToRegistration: $navigateToRegistration, onLoginSuccess: {
                            self.isLoggedIn = true
                        })
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
            .navigationBarTitle("Chore Assigner App", displayMode: .inline)
            .navigationBarItems(leading: LogoView(),
                                 trailing:
                                    Group {
                                        if isLoggedIn {
                                            Button(action: {
                                                userManager.logout()
                                                isLoggedIn = false
                                            }) {
                                                Image(systemName: "person.crop.circle.fill.badge.minus")
                                                    .foregroundColor(.red)
                                                    .padding(6)
                                                    .background(Color.white)
                                                    .clipShape(Circle())
                                                    .shadow(radius: 4)
                                            }
                                                                                   }
                                                                               }
                                                       )
                                                       .overlay(
                                                           // Loading indicator
                                                           Group {
                                                               if isLoading {
                                                                   LoadingIndicator()
                                                               }
                                                           }
                                                       )
                                                   }
                                                   .navigationViewStyle(StackNavigationViewStyle())
                                               }
                                           }

struct LoadingIndicator: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .background(Color.white) // Ensure the background color is set to white
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}


struct LogoView: View {
    var body: some View {
        Image(systemName: "house.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 32, height: 32)
            .padding(.leading, 10)
            .foregroundColor(.purple)
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
                .background(isSelected ? Color(red: 0.96, green: 0.94, blue: 0.90) : Color.clear)
                .cornerRadius(8)
            }
            .padding(.horizontal, 8)
        }
    }
    
    
    
    // MARK: - Admin Dashboard View
    
    struct AdminDashboardView: View {
        @EnvironmentObject var taskManager: TaskManager
        @EnvironmentObject var expenseManager: ExpenseManager
        
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
                        
                    }
                    
                    Spacer()
                }
                .navigationBarTitle("Admin Dashboard")
            }
        }
    }
    
    // MARK: - Regular User Dashboard View
    
    struct RegularUserDashboardView: View {
        
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
    
//MARK: CHores assigner
struct ChoresAssignerView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var assignedTask: Task?
    @State private var assignedTasks: [AssignedTask] = []
    @State private var isAssigningTask: Bool = false
    @State private var timer: Timer?
    @State private var assignedToName: String = ""
    
    struct AssignedTask {
        var task: Task
        var assignedTo: String
    }
    
    var body: some View {
        VStack {
            Text("Assigned Task:")
                .font(.headline)
                .padding()
            
            if let assignedTask = assignedTask {
                Text("\(assignedTask.title) - \(assignedToName)")
                    .font(.title)
                    .padding()
            } else if isAssigningTask {
                Text("Assigning task to \(assignedToName)...")
                    .font(.title)
                    .padding()
            } else {
                Text("No task assigned")
                    .font(.title)
                    .padding()
            }
            
            if isAssigningTask {
                Button("Stop") {
                    stopAssigningTask()
                }
                .padding()
            } else {
                TextField("Assign task to", text: $assignedToName)
                    .padding()
                Button("Lottery") {
                    startAssigningTask()
                }
                .padding()
            }
            
            if !assignedTasks.isEmpty {
                Divider()
                Text("Assigned Tasks:")
                    .font(.headline)
                    .padding(.top)
                ForEach(assignedTasks.indices, id: \.self) { index in
                    let task = assignedTasks[index]
                    Text("\(task.task.title) - \(task.assignedTo)")
                        .padding(.bottom, 4)
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startAssigningTask() {
        guard !assignedToName.isEmpty else { return }
        isAssigningTask = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            assignTask()
        }
    }
    private func stopAssigningTask() {
        isAssigningTask = false
        timer?.invalidate()

        if let task = assignedTask {
            assignedTasks.append(AssignedTask(task: task, assignedTo: assignedToName))
            taskManager.removeTask(withId: task.id) 
        }
        assignedTask = nil
    }
    
    private func assignTask() {
        if !taskManager.tasks.isEmpty {
            let randomIndex = Int.random(in: 0..<taskManager.tasks.count)
            assignedTask = taskManager.tasks[randomIndex]
        } else {
            assignedTask = nil
        }
    }

}




    #Preview{
        ContentView()
            .environmentObject(UserManager())
    }
