//
//  SceneDelegate.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import UIKit

class SceneDelegate:
    UIResponder,
    UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions:
            UIScene.ConnectionOptions
    ) {

        guard
            let windowScene =
                scene as? UIWindowScene
        else {
            return
        }

        let api =
            FPLAPI()

        let cache =
            FPLCache()

        let repository =
            FPLRepository(
                api: api,
                cache: cache
            )

        let viewModel =
            TeamsViewModel(
                repository: repository
            )

        let teamsViewController =
            TeamsViewController(
                viewModel: viewModel
            )

        let navigationController =
            UINavigationController(
                rootViewController:
                    teamsViewController
            )

        let window =
            UIWindow(
                windowScene: windowScene
            )

        window.rootViewController =
            navigationController

        self.window = window

        window.makeKeyAndVisible()
    }
}
