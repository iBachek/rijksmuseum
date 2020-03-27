import UIKit

import Services

protocol AppDelegateProtocol {
    var context: AppContext! { get }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppDelegateProtocol {

    var context: AppContext!
    static let sharedInstance = UIApplication.shared.delegate as! AppDelegateProtocol

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppContext(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func setupAppContext(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        context = AppContext.makeContext()

        let requestParameters = ArtObjectsParameters(offset: 0, limit: 10)
        context.dataService.getArtObjects(requestIdentifier: "123", parameters: requestParameters) { (result: Result<[ArtObject], APIError>) in
            switch result {
            case .success(let array):
                print(array)

            case .failure(let error):
                print(error)
            }
        }
    }
}

