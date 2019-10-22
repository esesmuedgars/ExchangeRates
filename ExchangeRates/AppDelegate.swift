//
//  AppDelegate.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var coordinator: Coordinator?

    private func setApperances() {
        let navBarApperance = UINavigationBar.appearance()
        navBarApperance.shadowImage = UIImage()
        navBarApperance.backIndicatorImage = UIImage()
        navBarApperance.isTranslucent = false
        navBarApperance.barTintColor = .white
        navBarApperance.titleTextAttributes = [
            .foregroundColor: UIColor.revolutBlack
        ]

    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setApperances()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        coordinator = AppCoordinator()
        coordinator?.startCoordinatorFlow()

        return true
    }
}

