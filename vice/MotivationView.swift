import AVKit
import SwiftUI

struct MotivationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var player: AVPlayer? = nil

    let videoURL: URL

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
                    .foregroundStyle(.black)
                    .padding()
                    .background(Color.white, in: Circle())
            }
            .padding()
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
