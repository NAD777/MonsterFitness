//
//  Router.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 12.04.2023.
//

import Foundation
import UIKit

class Router {
    let stoage = CoreStorage()
    let defaults = UserDefaults.standard
    let rootViewController: RootViewController

    init(rootViewController: RootViewController) {
        self.rootViewController = rootViewController
    }

    func start() {
        let coreStorage = CoreFoodManager(context: stoage.persistentContainer.viewContext)
        let homeScreenViewController = MainScreen(storage: coreStorage)
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
        let foodScreenViewController = FoodViewController()
        foodScreenViewController.bus = .init(
            onExit: { },
            onFoodSelected: { [weak self] (dish: Dish) -> Void in
                self?.openFoodEditor(dish: dish)
            })

        rootViewController.pushViewController(foodScreenViewController, animated: true)
    }
    
    func returnThePortion(portion: UIPortion) {
        stoage.savePortion(portion)
        rootViewController.popViewController(animated: true)
    }

    func openFoodEditor(dish: Dish) {
        let foodEditor = FoodEditor()
        foodEditor.bus = .init(
            weightFieldTap: { value in
                self.openWeightEnterViewController(value: value,
                                                   updateWeight: { newWeight in
                    foodEditor.bus?.data?.weight = Int(newWeight)
                })
            },
            onExit: { [returnThePortion] portion in
                returnThePortion(portion)
            })
        foodEditor.bus?.data = .init(dish: dish)
        rootViewController.pushViewController(foodEditor, animated: true)
    }

    func openWeightEnterViewController(
        value: String,
        updateWeight: @escaping (String) -> Void
    ) {
        let weightEditor = WeightEnterViewController()
        weightEditor.bus = .init(
            weight: value,
            onExit: { [updateWeight, weak self] result in
                updateWeight(result)
                self?.rootViewController.popViewController(animated: true)
            })
        rootViewController.pushViewController(weightEditor, animated: true)
    }

    func openProfile() {
        let profileViewController = ProfileViewController()
        profileViewController.onProfieChanged = { [weak self] in
            self?.rootViewController.popViewController(animated: true)
        }

        rootViewController.pushViewController(profileViewController, animated: true)
    }
}
