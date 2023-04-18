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
        let homeScreenViewController = MainScreen()
        homeScreenViewController.onSearchFoodSelected = { [weak self] in
            self?.openFood()
        }
        homeScreenViewController.onPersonSelected = { [weak self] in
            self?.openProfile()
        }

        let loggedIn = defaults.integer(forKey: "LoggedIn")
        if loggedIn == 1 {
            // TODO: - убрано изменение цвета, нужно придумать как прокинуть статус на экран лучше
//            homeScreenViewController.view.backgroundColor = .green
        } else {
//            homeScreenViewController.view.backgroundColor = .red
            defaults.set(1, forKey: "LoggedIn")
        }
        rootViewController.pushViewController(homeScreenViewController, animated: false)
    }

    func openFood() {
        let foodScreenViewController: FoodViewController = .init()
        foodScreenViewController.bus = .init { [weak self] in
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

    func openProfile() {
        let profileViewController = ProfileViewController()
        profileViewController.onProfieChanged = { [weak self] in
            self?.rootViewController.popViewController(animated: true)
        }

        rootViewController.pushViewController(profileViewController, animated: true)
    }
}
