import AVKit
import PhotosUI
import SwiftData
import SwiftUI

struct CreateHabitView: View {
    @Environment(\.modelContext) private var modelContext

    @Binding var isPresenting: Bool

    @State private var habitName: String = ""
    @State private var selectedVideo: PhotosPickerItem? = nil
    @State private var videoURL: URL? = nil
    @State private var reminders: [Reminder] = []
    @State private var createReminder: Reminder? = nil
    @State private var showCreateReminderSheet: Bool = false

    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Enter habit", text: $habitName)
                } header: {
                    Text("Habit")
                        .padding(.top, 10)
                }

                Section {
                    if let videoURL {
                        VideoPlayer(player: AVPlayer(url: videoURL))
                            .allowsHitTesting(false)
                            .frame(height: 200)
                    } else {
                        ContentUnavailableView {
                            Label("No video", systemImage: "video")
                        } description: {
                            Text("Select a video to remind yourself of your why")
                        }
                    }
                } header: {
                    HStack {
                        Text("Motivation")
                        Spacer()
                        PhotosPicker(selection: $selectedVideo, matching: .videos) {
                            Text("Choose motivation")
                        }
                    }
                }

                Section {
                    if reminders.isEmpty {
                        ContentUnavailableView {
                            Label("No reminders", systemImage: "alarm")
                        } description: {
                            Text("Add a time to remind yourself of your motivation to quit.")
                        }
                    } else {
                        List {
                            ForEach($reminders) { $r in
                                HStack {
                                    Text(
                                        "\(parseTimeComponent(value: r.hour)):\(parseTimeComponent(value: r.minute))"
                                    )
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
                        Spacer()
                        Button {
                            print("add new reminder")
                            showCreateReminderSheet = true
                        } label: {
                            Text("Add reminder")
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }

            ZStack {
                Button {
                    if let videoURL {
                        let habit = Habit(
                            id: UUID(), habit: habitName, motivation: videoURL, reminders: reminders
                        )

                        modelContext.insert(habit)

                        isPresenting = false
                    }
                } label: {
                    Text("Create habit")
                        .bold()
                        .foregroundStyle(.green)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    Rectangle()
                        .fill(.white)
                )
            }
        }
        .onChange(of: selectedVideo) {
            if let selectedVideo {
                Task {
                    let movie = try? await selectedVideo.loadTransferable(type: Movie.self)
                    if let movie {
                        videoURL = movie.url
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
    }

    func deleteItem(at offsets: IndexSet) {
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
        print("got here")
        return FileRepresentation(contentType: .movie) { (movie: Movie) in
            return SentTransferredFile(movie.url)
        } importing: { received in
            let copy = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension(received.file.pathExtension)
            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self(url: copy)
        }
    }
}
