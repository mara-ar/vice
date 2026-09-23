import SwiftUI

struct CreateHabitView: View {
    @State private var habitName: String = ""
    @State private var reminders: [(String, Bool)] = [("5:00 PM", true), ("6:00 PM", false)]

    var body: some View {
        Form {
            Section {
                TextField("Enter habit", text: $habitName)
            } header: {
                Text("Habit")
                    .padding(.top)
            }

            Section {
                List {
                    ForEach(reminders, id: \.0) { time, isActive in
                        HStack {
                            Text(time)
                            Spacer()
                            if isActive {
                                Image(systemName: "circle.fill")
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                    }
                    .onDelete(perform: deleteReminder)
                }
            } header: {
                Text("Reminders")
            } footer: {
                HStack {
                    Spacer()
                    Button {
                        print("clicked")
                    } label: {
                        Text("Add reminder")
                    }
                    .padding(.top, 5)
                }
            }

            Section {
                // TODO: photos and video picker
            } header: {
                Text("Motivation")
            }

            Button {
                print("create \(habitName)")
            } label: {
                HStack {
                    Spacer()
                    Text("Create habit")
                        .bold()
                    Spacer()
                }
            }
        }
    }

    private func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
    }
}
