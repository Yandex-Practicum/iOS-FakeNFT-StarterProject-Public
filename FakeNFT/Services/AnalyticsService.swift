import Foundation

enum Screens {
    enum Catalog {
        case main
    }
    enum Cart {
        case main
    }
    enum Profile {
        case main
    }
    enum Statistic {
        case main
    }
}

enum Events {
    case click
    case open
    case close
}

enum Items {
    case item
}

final class AnalyticsService {
    
    static let instance = AnalyticsService()

    private init() {}
    
    func sentEvents(screen: Screens, item: Items, event: Events) {
        var parameters: [AnyHashable: Any] = [:]
        parameters = [item: event]
        
//        YMMYandexMetrica.reportEvent(screen, parameters: parameters) { error in
//            print("REPORT ERROR: %@", error.localizedDescription)
//        }
    }
}
