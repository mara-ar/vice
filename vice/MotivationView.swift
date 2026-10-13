import AVKit
import SwiftUI

struct MotivationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var player: AVPlayer? = nil
    @State private var sheetManager: SheetManager = SheetManager.shared

    let videoURL: URL
    let isPreview: Bool

    init(videoURL: URL, isPreview: Bool = false) {
        self.videoURL = videoURL
        self.isPreview = isPreview
    }

    var body: some View {
        VideoPlayer(
            player: player
        )
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 17)
                    .padding(5)
            }
            .buttonBorderShape(.circle)
            .buttonStyle(.glass)
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
        }
        .overlay(alignment: .bottom) {
            if isPreview == false {
                Button {
                    sheetManager.checkInSheet = true
                } label: {
                    Text("Check in")
                        .font(.appFont(.headline))
                }
                .buttonStyle(.glass)
            }
        }
        .sheet(isPresented: $sheetManager.checkInSheet) {
            CheckInView()
                .presentationDetents([.medium])
                .presentationBackground(.white)
        }
        .task {
            player = AVPlayer(
                url: URL(
                    string:
                        "\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)\(videoURL.absoluteString)"
                )!)
            if let player {
                player.allowsExternalPlayback = false
            }
        }
    }
}
