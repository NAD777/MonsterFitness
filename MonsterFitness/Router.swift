//
//  Router.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 12.04.2023.
//

import Foundation
import UIKit

class Router {
    let storage = CoreStorage()
    let defaults = UserDefaults.standard
    let rootViewController: RootViewController
    lazy var coreStorage = CoreFoodManager(date: Calendar.current.startOfDay(for: Date()), context: storage.persistentContainer.viewContext)
    lazy var homeScreenViewController = MainScreen(storage: coreStorage)

    init(rootViewController: RootViewController) {
        self.rootViewController = rootViewController
    }

    func start() {
//        splashScreen()
        let today = Calendar.current.startOfDay(for: Date())
//        let coreStorage = CoreFoodManager(date: today, context: storage.persistentContainer.viewContext)
//        let homeScreenViewController = MainScreen(storage: coreStorage)
        openNewMain(date: today)
        let loggedIn = defaults.integer(forKey: "LoggedIn")
        if loggedIn == 1 {
        } else {
            let profileViewController = ProfileViewController()
            profileViewController.onProfieChanged = { [weak self] in
                self?.rootViewController.popViewController(animated: true)
            }
            rootViewController.pushViewController(profileViewController, animated: false)
            profileViewController.navigationItem.setHidesBackButton(true, animated: false)
            defaults.set(1, forKey: "LoggedIn")
        }
    }
    
    func splashScreen() {
        let splash = SplashViewController()
        splash.callBack = { [weak self] in
            self?.start()
        }
        rootViewController.pushViewController(splash, animated: false)
    }

    func openFood() {
        let foodScreenViewController = FoodViewController()
        let favStorage = CoreFavouritesDishManager(context: storage.persistentContainer.viewContext)
        foodScreenViewController.bus = .init(
            favouriteDishes: favStorage.allDishes,
            onExit: { },
            onFoodSelected: { [weak self] (dish: Dish, preference) -> Void in
                self?.openFoodEditor(dish: dish, preference: preference)
            },
            onDeleteFromFavourite: { [storage] (dish: Dish) -> Void in
                storage.deleteFavouriteDish(dish)
            },
            refreshFavouriteDishes: { [favStorage]
                return favStorage.refresh()
            }
        )

        rootViewController.pushViewController(foodScreenViewController,
                                              animated: true)
    }
    
    func returnThePortion(portion: UIPortion) {
        guard let date = topMainScreen?.date else {
            assertionFailure("main screen not found")
            return
        }
        storage.savePortion(portion, date: date)
        storage.saveDayResult(date)
        topMainScreen?.updateAll()
//        topMainScreen?.updateUser()
        rootViewController.popViewController(animated: true)
    }

    func openFoodEditor(dish: Dish, preference: FoodViewController.DishesLists.ListType) {
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
            },
            onFavouriteAdd: { [storage] dish in
                storage.saveFavouriteDish(dish)
            },
            onFavouriteDelete: { [storage] dish in
                storage.deleteFavouriteDish(dish)
            }
        )
        foodEditor.bus?.data = .init(dish: dish, preference: preference)
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
            print("onprofilechanged")
//            self?.homeScreenViewController.updateUser()
            self?.homeScreenViewController.updateAll()
        }

        rootViewController.pushViewController(profileViewController, animated: true)
    }

    func openCalendar(date: Date) {
        let manager = DayResultManager(day: date, context: storage.persistentContainer.viewContext)
        let calendarViewController = CalendarController(storage: manager)
        calendarViewController.onButtonDetails = { [weak self] in
            self?.openNewMain(date: calendarViewController.date)
        }
        rootViewController.pushViewController(calendarViewController, animated: true)
    }
    
    func openNewMain(date: Date) {
        let newMain = MainScreen(storage: CoreFoodManager(date: date, context: storage.persistentContainer.viewContext))
        
        newMain.onSearchFoodSelected = { [weak self] in
            self?.openFood()
        }
        newMain.onPersonSelected = { [weak self] in
            self?.openProfile()
        }
        newMain.onCalendarSelected = { [weak self] in
            self?.openCalendar(date: date)
        }
        rootViewController.pushViewController(newMain, animated: true)
    }

    var topMainScreen: MainScreen? {
        let mainScreens = rootViewController.viewControllers.compactMap {
            $0 as? MainScreen
        }
        return mainScreens.last
    }
}
