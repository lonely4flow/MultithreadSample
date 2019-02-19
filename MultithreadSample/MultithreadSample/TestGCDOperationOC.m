//
//  TestGCDOperationOC.m
//  MultithreadSample
//
//  Created by LonelyFlow on 18/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

#import "TestGCDOperationOC.h"

@implementation TestGCDOperationOC
+ (void) testGCDGroupDependency
{
    // 打印当前线程
    NSLog(@"###oc-gcd-begin-currentThread---%@",[NSThread currentThread]);
    
    dispatch_group_t group =  dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i=0;i<10;i++){
        int temps = (arc4random() % 5) + 1;
        dispatch_group_async(group, queue, ^{
            [NSThread sleepForTimeInterval:temps];
            NSLog(@"###oc-gcd i:%d-temp:%d-thread:%@",i,temps,NSThread.currentThread);
        });
    }
    dispatch_group_async(group, queue, ^{
        NSLog(@"###oc-gcd ------thread:%@",NSThread.currentThread);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"###oc-gcd ++++thread:%@",NSThread.currentThread);
    });
}

+ (void) testOperationGroupDependency1
{
    // 打印当前线程
    NSLog(@"###oc-operation1-begin-currentThread---%@",[NSThread currentThread]);
    NSMutableArray *ops = [NSMutableArray array];
    // 需要循环遍历添加执行任务的场景
    for (int i=0;i<10;i++) {
        int temps = (arc4random() % 5) + 1;
        NSOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            [NSThread sleepForTimeInterval:temps];
            NSLog(@"###oc-operation1 i:%d-wait:%d-thread:%@",i,temps,NSThread.currentThread);
        }];
        [ops addObject:op];
    }
    // 不是遍历添加的需要单独添加的任务
    TestGCDOperationOC *target = [TestGCDOperationOC new];
    NSOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:target selector:@selector(hello:) object:@"1"];
    [ops addObject:op1];
    // 其他Operation都执行完后再执行的Operation
    NSOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"###oc-operation1 ++++++thread:%@",NSThread.currentThread);
        });
    }];
    // 最后执行的任务对其他所有任务都添加依赖
    for (NSOperation *op in ops) {
        [op2 addDependency:op];
    }
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [ops addObject:op2];
    // 添加到任务队列中执行
    [queue addOperations:ops waitUntilFinished:false];
}
+ (void) testOperationGroupDependency2
{
    // 打印当前线程
    NSLog(@"###oc-operation2-begin-currentThread---%@",[NSThread currentThread]);
    NSBlockOperation *operation = [NSBlockOperation new];
    // 需要循环遍历添加执行任务的场景
    for (int i=0;i<10;i++) {
        int temps = (arc4random() % 5) + 1;
        [operation addExecutionBlock:^{
            [NSThread sleepForTimeInterval:temps];
            NSLog(@"###oc-operation2 i:%d-wait:%d-thread:%@",i,temps,NSThread.currentThread);
        }];
    }
    // 不是遍历添加的需要单独添加的任务
    TestGCDOperationOC *target = [TestGCDOperationOC new];
    [operation addExecutionBlock:^{
        [target hello:@"2"];
    }];
    
    // 其他Operation都执行完后再执行的任务
    operation.completionBlock = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"###oc-operation2 ++++++thread:%@",NSThread.currentThread);
        });
    };
    // 单个Operation可以直接使用start方法执行，也可以添加到OperationQueue中执行
    //[operation start];
    // 添加到任务队列中执行
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}
+ (void) testOperationGroupDependency3
{
    // 打印当前线程
    NSLog(@"###oc-operation3-begin-currentThread---%@",[NSThread currentThread]);
    NSBlockOperation *op0 = [NSBlockOperation new];
    // 需要循环遍历添加执行任务的场景
    for (int i=0;i<10;i++) {
        int temps = (arc4random() % 5) + 1;
        [op0 addExecutionBlock:^{
            [NSThread sleepForTimeInterval:temps];
            NSLog(@"###oc-operation3 i:%d-wait:%d-thread:%@",i,temps,NSThread.currentThread);
        }];
    }
    // 不是遍历添加的需要单独添加的任务
    TestGCDOperationOC *target = [TestGCDOperationOC new];
    NSOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:target selector:@selector(hello:) object:@"3"];
    // 其他Operation都执行完后再执行的Operation
    NSOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"###oc-operation3 ++++++thread:%@",NSThread.currentThread);
        });
    }];
    // 最后执行的任务对其他所有任务都添加依赖
    [op2 addDependency:op0];
    [op2 addDependency:op1];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 添加到任务队列中执行
    [queue addOperations:@[op0,op1,op2] waitUntilFinished:false];
}
- (void)hello:(NSString *)world
{
    NSLog(@"###oc-operation%@ --hello%@-- thread:%@",world,world,NSThread.currentThread);
}
@end
