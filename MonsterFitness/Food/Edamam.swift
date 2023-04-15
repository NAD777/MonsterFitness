//
//  Edamam.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 14.04.2023.
//

import Foundation


class Edamam {
    private struct CONFIG {
        static var APPLICATION_KEY = "8f20f988b3709d039a6eac0dac69f563"
        static var APP_ID = "0111f9ef"

    //    static var URL = "https://api.edamam.com/api/food-database/v2/parser"
        static let APIScheme = "https"
        static let APIHost = "api.edamam.com"
        static let APIPath = "/api/food-database/v2/parser"

    }

    static var shared: Edamam = {
        let instance = Edamam()
        return instance
    }()

    enum State {
        case Error
        case OK
    }

    private init() {}

//    func retriveDishes(name dishName: String, callBack: () -> Void) {
//        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//          // your code here
//        })
//        return
//    }

    func createUrlForDish(parameters: [String: Any], name dish: String) -> URL {
        let defaults = [
            "app_id": Edamam.CONFIG.APP_ID,
            "app_key": Edamam.CONFIG.APPLICATION_KEY,
            "ingr": dish
        ]
        var components = URLComponents()
        components.scheme = CONFIG.APIScheme
        components.host = CONFIG.APIHost
        components.path = CONFIG.APIPath
        if parameters.isEmpty {
            return components.url!
        }

        for (key, value) in defaults {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
}
