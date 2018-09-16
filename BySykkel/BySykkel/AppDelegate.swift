//
//  AppDelegate.swift
//  BySykkel
//
//  Created by Torp, Thomas on 14/09/2018.
//  Copyright © 2018 Torp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let token = ""

        let api = BySykkelAPI(token: token)
        let vm = BySykkelViewModel(api: api)
        let listViewController = BySykkelViewController(viewModel: vm)
        let mapViewController = BySykkelMapViewController(viewModel: vm)

        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.setViewControllers([listViewController, mapViewController], animated: true)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }
}

