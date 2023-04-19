//
//  Edamam.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 14.04.2023.
//
import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let text: String
    let parsed: [Parsed]
    let hints: [Hint]
}

// MARK: - Hint
struct Hint: Codable {
    let food: Food
    let measures: [Measure]
}

// MARK: - Food
struct Food: Codable {
    let foodId: String
    let label: String
    let knownAs: String
    let nutrients: Nutrients
    let image: String?
}

// MARK: - Nutrients
struct Nutrients: Codable {
    let enercKcal: Double
    let procnt: Double
    let fat: Double
    let chocdf: Double
    let fibtg: Double

    enum CodingKeys: String, CodingKey {
        case enercKcal = "ENERC_KCAL"
        case procnt = "PROCNT"
        case fat = "FAT"
        case chocdf = "CHOCDF"
        case fibtg = "FIBTG"
    }
}

// MARK: - Measure
struct Measure: Codable {
    let uri: String
    let label: String
    let weight: Double
}

// MARK: - Parsed
struct Parsed: Codable {
    let food: Food
}

class Edamam {
    private struct CONFIG {
        static let APPLICATION_KEY = "8f20f988b3709d039a6eac0dac69f563"
        static let APP_ID = "0111f9ef"
        static let APIScheme = "https"
        static let APIHost = "api.edamam.com"
        static let APIPath = "/api/food-database/v2/parser"
    }
//    static var shared: Edamam = {
//        let instance = Edamam()
//        return instance
//    }()
    static let shared = Edamam()
    enum State {
        case Error
        case OK
    }
    private init() {}
    func retriveDishes(name dishName: String, callBack: @escaping ([Dish]) -> Void) {
        let url = createUrlForDish(name: dishName)
        guard let url = url else {
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if let data = data,
                let dishResponce = try? JSONDecoder().decode(Welcome.self, from: data) {
                var resultOfParsing: [Dish] = .init()
                for hint in dishResponce.hints {
                    let title = hint.food.label
                    let kcal = Double(hint.food.nutrients.enercKcal)
                    let fat = Double(hint.food.nutrients.fat)
                    let carb = Double(hint.food.nutrients.chocdf)
                    let prot = Double(hint.food.nutrients.procnt)
                    resultOfParsing.append(Dish(title: title, kcal: kcal, prot: prot, fat: fat, carb: carb))
                }
                callBack(resultOfParsing)
            }
        })
        task.resume()
    }

    func createUrlForDish(name dish: String) -> URL? {
        let defaults = [
            "app_id": Edamam.CONFIG.APP_ID,
            "app_key": Edamam.CONFIG.APPLICATION_KEY,
            "ingr": dish
        ]
        var components = URLComponents()
        components.scheme = CONFIG.APIScheme
        components.host = CONFIG.APIHost
        components.path = CONFIG.APIPath

        components.queryItems = [URLQueryItem]()
        for (key, value) in defaults {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
}
