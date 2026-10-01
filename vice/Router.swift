import Combine
import SwiftUI

enum Route: Hashable {
    case motivation(url: URL)
}

class Router: ObservableObject {
    @Published var path: [Route] = []
}
