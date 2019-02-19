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
        TestGCDOperationOC.testGCDGroupDependency()
        TestGCDOperationOC.testOperationGroupDependency1()
        TestGCDOperationOC.testOperationGroupDependency2()
        TestGCDOperationOC.testOperationGroupDependency3()
        //-----------
        
        TestGCDOperationSwift.testGCDGroupDependency()
        TestGCDOperationSwift.testOperationGroupDependency1()
        TestGCDOperationSwift.testOperationGroupDependency2()
        TestGCDOperationSwift.testOperationGroupDependency3()
    }
    
}

