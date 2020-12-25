//
//  ViewController.swift
//  JDGFrameworks
//
//  Created by jessiegan1987@163.com on 12/24/2020.
//  Copyright (c) 2020 jessiegan1987@163.com. All rights reserved.
//

import UIKit
import JDGFrameworks

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        JDGLog.default.displaySpace.append(.specific(name: "UI"))
        JDGLog.default.displaySpace.append(.specific(name: "Logic"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showLogPressed(_ sender: Any) {
        if arc4random()%2 == 1 {
            JLError("测试代码1", space: .specific(name: "Logic"))
        } else {
            JLMessage("测试代码2", space: .specific(name: "UI"))
        }
    }
}
