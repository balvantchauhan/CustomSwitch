//
//  ViewController.swift
//  CustomSwitch
//
//  Created by Balvant Singh Chauhan on 27/05/19.
//  Copyright © 2019 Balvant Singh Chauhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func swtchTapped(_ sender: CustomSwitch) {
        print("switch",sender.isOn)
    }
}

