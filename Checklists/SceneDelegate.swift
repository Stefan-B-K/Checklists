//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  let dataModel = DataModel()
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    let navigationController = window!.rootViewController as! UINavigationController
      let controller = navigationController.viewControllers[0] as! ListsViewController
      controller.dataModel = dataModel
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    dataModel.saveLists()
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    dataModel.saveLists()
  }
  
}

