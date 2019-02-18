//
//  ViewController.swift
//  MultithreadSample
//
//  Created by LonelyFlow on 18/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TestGCDOperationOC.testOperation()
        TestGCDOperationOC.testGCDGroup()
        //-----------
        TestGCDOperationSwift.testOperation()
        TestGCDOperationSwift.testGCDGroup()
    }
    
}

