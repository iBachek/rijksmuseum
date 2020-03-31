import UIKit

public protocol AlertServiceHolderProtocol {
    var alertService: AlertServiceProtocol { get }
}

public protocol AlertServiceProtocol: AnyObject {
    func showMessage(_ message: String, viewController: UIViewController?)
}

public final class AlertService: AlertServiceProtocol {

    public init() {
        
    }

    public func showMessage(_ message: String, viewController: UIViewController?) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
        alertController.addAction(doneAction)
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
