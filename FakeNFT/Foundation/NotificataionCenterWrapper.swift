import Foundation

typealias NotificationObserver = NSObjectProtocol

final class NotificationCenterWrapper {
    enum NotificationType: String {
        case showCatalog = "RequestShowCatalog"
    }

    static let shared = NotificationCenterWrapper()
    private init() {}

    private let notificationCenter = NotificationCenter.default

    private var notificationObservers: [NotificationType: NotificationObserver] = [:]

    func sendNotification(type: NotificationType) {
        let notificationName = Notification.Name(rawValue: type.rawValue)
        notificationCenter.post(
            name: notificationName,
            object: nil,
            userInfo: ["type": type]
        )
    }

    func subscribeToNotification(type: NotificationType, handler: @escaping ActionCallback<Notification>) {
        let notificationName = Notification.Name(rawValue: type.rawValue)
        let observer = notificationCenter.addObserver(
            forName: notificationName,
            object: nil,
            queue: .main,
            using: handler
        )

        self.notificationObservers[type] = observer
    }
}
