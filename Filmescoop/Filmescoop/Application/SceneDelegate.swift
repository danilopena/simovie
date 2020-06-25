//
//  SceneDelegate.swift
//  ios-view-code
//
//  Created by Danilo Pena on 19/04/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    internal var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UIStoryboard(name: StoryboardIdentifier.main, bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        
        navigationStyle()
    }
}

