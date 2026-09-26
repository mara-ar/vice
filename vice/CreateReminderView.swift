import SwiftUI

struct CreateReminderView: View {
    @Binding var reminder: Reminder?
    @Binding var isPresenting: Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    print("submit reminder creation")
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

            Text("time picker here")

            Spacer()
        }
        .padding()
    }
}
