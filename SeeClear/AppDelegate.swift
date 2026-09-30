//
//  AppDelegate.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import UIKit

@main
class AppDelegate:
    UIResponder,
    UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession:
        UISceneSession,
        options:
        UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        UISceneConfiguration(
            name: "Default Configuration",
            sessionRole:
                connectingSceneSession.role
        )
    }
}
