import UIKit

struct OnboardingPage {
    let image: ImageResource
    let title: String
}

enum UserDefaultsKeys {
    static let hasSeenOnboarding = "hasSeenOnboarding"
}

enum ImageResource {
    case background1
    case background2

    var name: String {
        switch self {
        case .background1: return "background1"
        case .background2: return "background2"
        }
    }
}
