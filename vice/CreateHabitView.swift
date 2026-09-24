import SwiftUI

struct CreateHabitView: View {
    @State private var habitName: String = ""
    @State private var reminders: [Reminder] = [
        Reminder(time: "5:00 PM", isActive: true),
        Reminder(time: "6:00 PM", isActive: false),
    ]

    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Enter habit", text: $habitName)
                } header: {
                    Text("Habit")
                        .padding(.top, 10)
                }

                // TODO: motivation

                Section {
                    if reminders.isEmpty {
                        ContentUnavailableView {
                            Label("No reminders", systemImage: "alarm")
                        } description: {
                            Text("Add a time to remind yourself of your motivation to quit.")
                        }
                    } else {
                        List {
                            ForEach(reminders) { r in
                                HStack {
                                    Text(r.time)
                                    Spacer()
                                    r.isActive
                                        ? Image(systemName: "circle.fill")
                                        : Image(systemName: "circle")
                                }
                            }
                            .onDelete(perform: deleteItem)
                        }
                    }
                } header: {
                    HStack {
                        Text("Reminders")
                        Spacer()
                        Button {
                            print("add new reminder")
                            reminders.append(Reminder(time: "5:00 PM", isActive: false))
                        } label: {
                            Text("Add reminder")
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }

            Button {
                print("create habit")
            } label: {
                Text("Create habit")
                    .bold()
                    .foregroundStyle(.green)
            }
            .buttonStyle(.plain)
            .padding()
        }
    }

    func deleteItem(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
    }
}
