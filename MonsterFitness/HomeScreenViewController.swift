//
//  HomeScreenViewController.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 12.04.2023.
//

import UIKit

class HomeScreenViewController: UIViewController {
    // Bus translation model
    struct Model {
        struct InputData {
            var a: Int
        }
        struct OutputData {

        }
        var data: InputData?
        var onExit: () -> Void
        var output: OutputData?
    }

    var bus: Model?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white

        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.setTitle("Food", for: .normal)
        button.layer.position = view.center
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func buttonAction(sender: UIButton!) {
        bus?.onExit()
    }
}
