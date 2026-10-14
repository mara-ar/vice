import SwiftUI

enum Status {
    case neutral
    case relapsed
    case resisted
}

struct CheckInView: View {
    @State private var status: Status = .neutral
    @State private var sheetManager: SheetManager = SheetManager.shared
    @State private var reflection: String = ""

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

            TextField("Enter your reflection here...", text: $reflection, axis: .vertical)
                .font(.appFont(.callout))
                .lineLimit(5...)
                .background(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                )

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .overlay(alignment: .topTrailing) {
            Button {
                print("confirm check in and dismiss sheet")
                sheetManager.checkInSheet = false
            } label: {
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
            }
            .padding(12)
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .glassEffect(.regular.tint(.green.opacity(1)).interactive(), in: Circle())
            .contentShape(.circle)
        }
        .padding()
    }
}
