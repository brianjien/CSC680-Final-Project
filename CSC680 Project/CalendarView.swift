import SwiftUI
import EventKit
import EventKitUI

struct CalendarView: View {
    @State private var events: [EKEvent] = []

    var body: some View {
        VStack {
            Text("Calendar View")
                .font(.largeTitle)
                .padding()

            List(events, id: \.eventIdentifier) { event in
                Text(event.title ?? "No title")
            }
        }
        .onAppear {
            fetchEvents()
        }
        .navigationBarTitle("Calendar")
    }

    private func fetchEvents() {
        let store = EKEventStore()
        store.requestAccess(to: .event) { granted, error in
            if let error = error {
                print("Error fetching events: \(error.localizedDescription)")
                return
            }

            if granted {
                let startDate = Date()
                let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)!
                let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
                events = store.events(matching: predicate)
            } else {
                print("Access to calendar not granted")
            }
        }
    }
}

#if DEBUG
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
#endif
