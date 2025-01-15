import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let rootViewController = HomeViewController() // 루트 뷰 컨트롤러로 설정
        let navigationController = UINavigationController(rootViewController: rootViewController) // 네비게이션 컨트롤러로 감싸기
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        applyTheme()
        self.window = window
    }
}

extension SceneDelegate {
    func applyTheme() {
        let savedValue = UserDefaults.standard.integer(forKey: UserDefaultsKeys.appTheme.rawValue)
        let userInterfaceStyle: UIUserInterfaceStyle = (savedValue == UIUserInterfaceStyle.dark.rawValue) ? .dark : .light
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = userInterfaceStyle
            }
        }
    }
}
