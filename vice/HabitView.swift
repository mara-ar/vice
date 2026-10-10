import AVKit
import PhotosUI
import SwiftData
import SwiftUI
import UserNotifications

struct HabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var originalHabit: Habit?
    var isCreatingNewHabit: Bool {
        originalHabit == nil
    }

    @State private var habitName: String = ""
    // @State private var notification: Notification? = Notification(
    //     notificationHeading: "", notificationContent: "")
    @State private var notificationHeading: String = ""
    @State private var notificationContent: String = ""
    @State private var selectedVideo: PhotosPickerItem? = nil
    @State private var videoURL: URL? = nil
    @State private var reminders: [Reminder] = []
    @State private var createReminder: Reminder? = nil
    @State private var showCreateReminderSheet: Bool = false
    @State private var showPreview: Bool = false

    init(
        originalHabit: Habit? = nil
    ) {
        self.originalHabit = originalHabit
        if let unwrappedOriginalHabit = originalHabit {
            self._habitName = State(initialValue: unwrappedOriginalHabit.habit)
            self._videoURL = State(initialValue: unwrappedOriginalHabit.motivation)
            self._reminders = State(initialValue: unwrappedOriginalHabit.reminders)
            self._notificationHeading = State(
                initialValue: unwrappedOriginalHabit.notificationHeading)
            self._notificationContent = State(
                initialValue: unwrappedOriginalHabit.notificationContent)
        }
    }

    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Enter habit", text: $habitName)
                        .font(.appFont(.body))
                } header: {
                    Text("Habit")
                        .padding(.top, 30)
                        .font(.appFont(.headline))
                }

                Section {
                    TextField(
                        "Enter notification heading", text: $notificationHeading
                    )
                    .font(.appFont(.body))
                    TextField(
                        "Enter notification content", text: $notificationContent
                    )
                    .font(.appFont(.body))
                } header: {
                    Text("Notification")
                        .font(.appFont(.headline))
                }

                Section {
                    if let videoURL {
                        VideoPlayer(
                            player: AVPlayer(
                                url: URL(
                                    string:
                                        "\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)\(videoURL.absoluteString)"
                                )!)
                        )
                        .allowsHitTesting(false)
                        .frame(height: 200)
                    } else {
                        ContentUnavailableView {
                            Image(systemName: "video")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .padding()
                                .bold()
                        } description: {
                            Text("Select a video to remind yourself of your why")
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.appFont(.subheadline))
                        }
                        .frame(height: 150)
                    }
                } header: {
                    HStack {
                        Text("Motivation")
                            .font(.appFont(.headline))
                        Spacer()
                        PhotosPicker(selection: $selectedVideo, matching: .videos) {
                            Text("Choose motivation")
                                .font(.appFont(.subheadline))
                        }
                    }
                } footer: {
                    Button {
                        showPreview = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Preview")
                                .font(.appFont(.subheadline))
                        }
                    }
                }

                Section {
                    if reminders.isEmpty {
                        ContentUnavailableView {
                            Image(systemName: "alarm")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .padding()
                                .bold()
                        } description: {
                            Text("Add a time to remind yourself of your motivation to quit.")
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.appFont(.subheadline))
                        }
                        .frame(height: 150)
                    } else {
                        List {
                            ForEach($reminders) { $r in
                                HStack {
                                    Text(
                                        "\(parseTimeComponent(value: r.hour)):\(parseTimeComponent(value: r.minute))"
                                    )
                                    .font(.appFont(.body))
                                    Spacer()
                                    r.isActive
                                        ? Image(systemName: "circle.fill")
                                        : Image(systemName: "circle")
                                }
                                .onTapGesture {
                                    r.isActive.toggle()
                                }

                            }
                            .onDelete(perform: deleteItem)
                        }
                    }
                } header: {
                    HStack {
                        Text("Reminders")
                            .font(.appFont(.headline))
                        Spacer()
                        Button {
                            showCreateReminderSheet = true
                        } label: {
                            Text("Add reminder")
                                .font(.appFont(.subheadline))
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    if let videoURL {
                        let habit = Habit(
                            id: UUID(), habit: habitName, motivation: videoURL,
                            reminders:
                                reminders, notificationHeading: notificationHeading,
                            notificationContent: notificationContent
                        )

                        _ =
                            isCreatingNewHabit
                            ? Task {
                                do {
                                    modelContext.insert(habit)
                                    try modelContext.save()
                                    reminders.forEach { r in
                                        if r.isActive {
                                            NotificationManager.instance.scheduleNotification(
                                                title: notificationHeading,
                                                body: notificationContent, reminder: r,
                                                motivationURL: habit.motivation)
                                        }
                                    }
                                    dismiss()
                                } catch {
                                    print("\(error)")
                                }
                            }
                            : Task {
                                if let originalHabit {
                                    originalHabit.habit = habitName
                                    originalHabit.motivation = videoURL
                                    originalHabit.reminders = reminders
                                    originalHabit.notificationHeading = notificationHeading
                                    originalHabit.notificationContent = notificationContent

                                    reminders.forEach { r in
                                        NotificationManager.instance.updateNotification(
                                            reminder: r, isActive: r.isActive,
                                            motivationURL: habit.motivation)
                                    }

                                    try modelContext.save()
                                    dismiss()
                                }
                            }

                    }
                } label: {
                    Image(systemName: "checkmark")
                        .bold()
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(
                            Circle()
                                .fill(.green)
                                .shadow(color: .green, radius: 5)
                        )
                }
                .padding()
            }
        }
        .onChange(of: selectedVideo) {
            if let selectedVideo {
                Task {
                    let movie = try? await selectedVideo.loadTransferable(type: Movie.self)
                    if let movie {
                        videoURL = URL(string: movie.url.lastPathComponent)
                    } else {
                        print("unsuccessful")
                    }
                }
            }
        }
        .sheet(isPresented: $showCreateReminderSheet) {
            CreateReminderView(reminders: $reminders, isPresenting: $showCreateReminderSheet)
                .presentationDetents([.medium])
        }
        .fullScreenCover(isPresented: $showPreview) {
            if let videoURL {
                MotivationView(videoURL: videoURL)
            }
        }
    }

    func deleteItem(at offsets: IndexSet) {
        guard let index = offsets.first else { return }

        let habit = reminders[index]

        NotificationManager.instance.deleteNotification(id: habit.id)
        reminders.remove(atOffsets: offsets)
    }

    func parseTimeComponent(value: Int) -> String {
        if value < 10 {
            return "0\(value)"
        }
        return "\(value)"
    }
}

struct Movie: Transferable {
    let url: URL
    static var transferRepresentation: some TransferRepresentation {
        return FileRepresentation(contentType: .movie) { (movie: Movie) in
            return SentTransferredFile(movie.url)
        } importing: { received in
            let copy = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension(received.file.pathExtension)
            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self(url: copy)
        }
    }
}
