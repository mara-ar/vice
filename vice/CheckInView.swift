import SwiftUI

enum Status {
    case neutral
    case relapsed
    case resisted
}

struct CheckInView: View {
    @State private var status: Status = .neutral
    var body: some View {
        VStack {
            Text("Check in")
                .font(.appFont(.title2))
            HStack(spacing: 25) {
                Button {
                    print("relapsed")
                    status = .relapsed
                } label: {
                    Text("relapsed")
                        .font(.appFont(.headline))
                        .foregroundStyle(.red)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.roundedRectangle)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.red.opacity(status == .relapsed ? 0.1 : 0))
                        .stroke(.red, style: .init(lineWidth: status == .relapsed ? 3 : 0))
                )

                Button {
                    print("resisted")
                    status = .resisted
                } label: {
                    Text("resisted")
                        .font(.appFont(.headline))
                        .foregroundStyle(.green)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.roundedRectangle)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.green.opacity(status == .resisted ? 0.1 : 0))
                        .stroke(.green, style: .init(lineWidth: status == .resisted ? 3 : 0))
                )
            }
        }
        .padding()
    }
}
