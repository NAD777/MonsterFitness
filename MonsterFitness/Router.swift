//
//  Router.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 12.04.2023.
//

import Foundation
import UIKit


class Router {
    let defaults = UserDefaults.standard

    var rootViewController: RootViewController

    init(rootViewController: RootViewController) {
        self.rootViewController = rootViewController
    }

    func start() {
        let homeScreenViewController = HomeScreenViewController()
        homeScreenViewController.bus = HomeScreenViewController.Model { [weak self] in
            self?.openFood()
        }
        let loggedIn = defaults.integer(forKey: "LoggedIn")
        if loggedIn == 1 {
            homeScreenViewController.view.backgroundColor = .green
        } else {
            homeScreenViewController.view.backgroundColor = .red
            defaults.set(1, forKey: "LoggedIn")
        }
        rootViewController.pushViewController(homeScreenViewController, animated: false)
    }

    func openFood() {
        let foodScreenViewController = FoodViewController()
        foodScreenViewController.bus = FoodViewController.Model { [weak self] in
            print(foodScreenViewController.bus?.output ?? "NONE")
            self?.rootViewController.popViewController(animated: true)
        }
        rootViewController.pushViewController(foodScreenViewController, animated: true)
    }
}
