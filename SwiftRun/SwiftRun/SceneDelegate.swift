import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let rootViewController = WordListViewController() // 루트 뷰 컨트롤러로 설정
        let navigationController = UINavigationController(rootViewController: rootViewController) // 네비게이션 컨트롤러로 감싸기
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
