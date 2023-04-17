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

    let rootViewController: RootViewController

    init(rootViewController: RootViewController) {
        self.rootViewController = rootViewController
    }

    func start() {
//        openFood()
//        openWeight()
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
        let foodScreenViewController: FoodViewController = .init()
        foodScreenViewController.bus = .init() { [weak self] in
            print(foodScreenViewController.bus?.output ?? "NONE")
            self?.rootViewController.popViewController(animated: true)
        }
        rootViewController.pushViewController(foodScreenViewController, animated: true)
    }

    func openWeight() {
        let foodScreenViewController = WeightEnterViewController()
//        foodScreenViewController.bus = FoodViewController.Model { [weak self] in
//            print(foodScreenViewController.bus?.output ?? "NONE")
//            self?.rootViewController.popViewController(animated: true)
//        }
        rootViewController.pushViewController(foodScreenViewController, animated: true)
    }
}
