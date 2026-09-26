import SwiftUI

struct CreateReminderView: View {
    @Binding var reminders: [Reminder]
    @Binding var isPresenting: Bool
    @State private var date: Date = Date()

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    print("submit reminder")
                    let hour = Calendar.current.component(.hour, from: date)
                    let minute = Calendar.current.component(.minute, from: date)
                    reminders.append(Reminder(hour: hour, minute: minute, isActive: false))
                    reminders = reminders.sorted {
                        if $0.hour == $1.hour {
                            return $0.minute < $1.minute
                        }
                        return $0.hour < $1.hour
                    }
                    isPresenting = false
                } label: {
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16)
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            Circle()
                                .fill(.tint)
                                .shadow(color: .blue, radius: 3, y: 1)
                        )
                }
            }

            DatePicker("", selection: $date, displayedComponents: [.hourAndMinute])
                .datePickerStyle(.wheel)
                .labelsHidden()

            Spacer()
        }
        .padding()
    }
}
