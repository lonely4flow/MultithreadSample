//
//  TestGCDOperationSwift.swift
//  MultithreadSample
//
//  Created by LonelyFlow on 18/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class TestGCDOperationSwift: NSObject {
    class func testGCDGroup() -> Void
    {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "labelname", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit)
        for i in 0..<10 {
            let temps:Int = Int(arc4random_uniform(3))+3
            queue.async(group: group, execute: DispatchWorkItem(block: {
                Thread.sleep(forTimeInterval: TimeInterval(temps))
                print("###swift-gcd i \(i)-\(temps)-\(Thread.current)")
            }))
            
        }
        queue.async(group: group, execute: DispatchWorkItem(block: {
            print("###swift-gcd-------\(Thread.current)")
        }))
        
        group.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
            print("###swift-gcd+++++-\(Thread.current)")
        }))
        
        
    }
    class func testOperation() -> Void
    {
        var ops: [Operation] = []
        for i in 0..<10 {
            let temps:Int = Int(arc4random_uniform(3))+1
            ops.append(BlockOperation(block: {
                sleep(UInt32(temps))
                print("###swift-operation i \(i)-\(temps)-\(Thread.current)")
            }))
        }
        let op1 = BlockOperation {
            print("###swift-operation -------\(Thread.current)")
        }
        ops.append(op1)
        let op2 = BlockOperation {
            DispatchQueue.main.async {
                print("###swift-operation +++++-\(Thread.current)")
            }
            
        }
        for op in ops {
            op2.addDependency(op)
        }
        ops.append(op2)
        let queue = OperationQueue()
        // queue.addOperation(op2)
        for op in ops {
            queue.addOperation(op)
        }
    }
}
