//
//  TestGCDOperationSwift.swift
//  MultithreadSample
//
//  Created by LonelyFlow on 18/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class TestGCDOperationSwift: NSObject {
    class func testGCDGroupDependency() -> Void
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
    class func testOperationGroupDependency1() -> Void
    {
        var ops: [Operation] = []
        // 需要循环遍历添加执行任务的场景
        for i in 0..<10 {
            let temps:Int = Int(arc4random_uniform(3))+1
            ops.append(BlockOperation(block: {
                sleep(UInt32(temps))
                print("###swift-operation1 i:\(i)-wait:\(temps)-thread:\(Thread.current)")
            }))
        }
        // 不是遍历添加的需要单独添加的任务
        let op1 = BlockOperation {
            print("###swift-operation1 -------\(Thread.current)")
        }
        ops.append(op1)
        let op2 = BlockOperation {
            DispatchQueue.main.async {
                print("###swift-operation1 +++++-\(Thread.current)")
            }
            
        }
        // 最后执行的任务对其他所有任务都添加依赖
        for op in ops {
            op2.addDependency(op)
        }
        ops.append(op2)
        let queue = OperationQueue()
        // 添加到任务队列中执行
       queue.addOperations(ops, waitUntilFinished: false)
    }
    class func testOperationGroupDependency2() -> Void
    {
        let operation: BlockOperation = BlockOperation()
        // 需要循环遍历添加执行任务的场景
        for i in 0..<10 {
            let temps:Int = Int(arc4random_uniform(3))+1
            operation.addExecutionBlock {
                sleep(UInt32(temps))
                print("###swift-operation2 i:\(i)-wait:\(temps)-thread:\(Thread.current)")
            }
        }
        // 不是遍历添加的需要单独添加的任务
        operation.addExecutionBlock {
            print("###swift-operation2 -------\(Thread.current)")
        }
        // 最后执行的任务
        operation.completionBlock = {
            DispatchQueue.main.async {
                print("###swift-operation2 +++++-\(Thread.current)")
            }
        }
        // 单个Operation可以直接使用start方法执行，也可以添加到OperationQueue中执行
       // operation.start()
        let queue = OperationQueue()
        queue.addOperation(operation)
    }
    class func testOperationGroupDependency3() -> Void
    {
        let op0: BlockOperation = BlockOperation()
        // 需要循环遍历添加执行任务的场景
        for i in 0..<10 {
            let temps:Int = Int(arc4random_uniform(3))+1
            op0.addExecutionBlock {
                sleep(UInt32(temps))
                print("###swift-operation3 i:\(i)-wait:\(temps)-thread:\(Thread.current)")
            }
        }
        // 不是遍历添加的需要单独添加的任务
        // swift没有NSInvocationOperation，Objective-C里有，
        //一些场景下比如原有代码里已经存在一个方法可以实现需求，只需要用NSInvocationOperation的target、selector就能做到了
        let op1 = BlockOperation{
            print("###swift-operation3 -------\(Thread.current)")
        }
        // 需要之前的任务都完成后再执行的任务
        let op2 = BlockOperation {
            DispatchQueue.main.async {
                print("###swift-operation3 +++++-\(Thread.current)")
            }
            
        }
        // 最后执行的任务对其他所有任务都添加依赖
        op2.addDependency(op0)
        op2.addDependency(op1)
        // 添加到任务队列中执行
        let queue = OperationQueue()
        queue.addOperations([op0,op1,op2], waitUntilFinished: false)
    }
}
