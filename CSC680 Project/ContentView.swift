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

struct User {
    var username: String
    var password: String
    var role: UserRole
}

enum UserRole {
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
    @State private var isLoading: Bool = false // Add loading state

    var body: some View {
        NavigationView {
            VStack {
                if isLoggedIn {
                    TabView {
                        TaskListView(taskManager: TaskManager())
                            .tabItem {
                                Label("Tasks", systemImage: "list.bullet")
                            }
                        
                        ExpenseListView(expenseManager: ExpenseManager())
                            .tabItem {
                                Label("Expenses", systemImage: "square.and.pencil")
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
    
    
    
    
    
    
    // MARK: - Expense Editor View
    struct ExpenseEditorView: View {
        @ObservedObject var expenseManager: ExpenseManager
        @Binding var isPresented: Bool
        
        var expense: Expense?
        
        @State private var amount: String = ""
        @State private var category: String = ""
        @State private var contributors: String = ""
        @State private var date: Date = Date()
        @State private var isSettled: Bool = false
        @State private var isSaving: Bool = false
        
        var body: some View {
            Form {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Category", text: $category)
                TextField("Contributors", text: $contributors)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                Toggle("Settled", isOn: $isSettled)
                
                Button(action: {
                    isSaving = true
                    saveExpense()
                }) {
                    Text("Save")
                }
                .disabled(isSaving)
            }
            .onAppear {
                if let expense = expense {
                    amount = "\(expense.amount)"
                    category = expense.category
                    contributors = expense.contributors.joined(separator: ", ")
                    date = expense.date
                    isSettled = expense.isSettled
                }
            }
            .navigationBarTitle(expense != nil ? "Edit Expense" : "Add Expense")
        }
        
        private func saveExpense() {
            let contributorsArray = contributors.components(separatedBy: ",")
            let updatedExpense = Expense(amount: Double(amount) ?? 0.0, category: category, contributors: contributorsArray, date: date, isSettled: isSettled)
            if let expense = expense {
                expenseManager.updateExpense(at: expenseManager.expenses.firstIndex(of: expense)!, with: updatedExpense)
            } else {
                expenseManager.addExpense(expense: updatedExpense)
            }
            
            expenseManager.saveExpenses()
            
            isSaving = false
            isPresented = false
        }
    }
    
    
    
    struct ExpenseRow: View {
        var expense: Expense
        var onEdit: () -> Void
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount: \(expense.amount)")
                        .font(.headline)
                    Text("Category: \(expense.category)")
                        .font(.subheadline)
                    Text("Contributors: \(expense.contributors.joined(separator: ", "))")
                        .font(.subheadline)
                    Text("Date: \(expense.date, formatter: dateFormatter)")
                        .font(.subheadline)
                }
                .padding(.vertical)
                
                Spacer()
                
                Button(action: {
                    onEdit()
                }) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.blue)
                }
            }
        }
        
        private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
        }()
    }
    
    #Preview{
        ContentView()
            .environmentObject(UserManager())
    }

