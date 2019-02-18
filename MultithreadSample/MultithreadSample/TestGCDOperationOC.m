//
//  TestGCDOperationOC.m
//  MultithreadSample
//
//  Created by LonelyFlow on 18/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

#import "TestGCDOperationOC.h"

@implementation TestGCDOperationOC
+ (void) testGCDGroup
{
    
    NSLog(@"###oc-gcd--currentThread---%@",[NSThread currentThread]);  // 打印当前线程
   // NSLog(@"group---begin");
    
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
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"###oc-gcd ++++thread:%@",NSThread.currentThread);
    });
}

+ (void) testOperation
{
    NSLog(@"###oc-operation--currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    //NSLog(@"###oc-operation---begin");
    NSMutableArray *ops = [NSMutableArray array];
    for (int i=0;i<10;i++) {
        int temps = (arc4random() % 5) + 1;
        NSOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            [NSThread sleepForTimeInterval:temps];
            NSLog(@"###oc-operation i:%d-temp:%d-thread:%@",i,temps,NSThread.currentThread);
        }];
        [ops addObject:op];
    }
    NSOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"###oc-operation ------thread:%@",NSThread.currentThread);
    }];
    [ops addObject:op1];
    NSOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"###oc-operation ++++++thread:%@",NSThread.currentThread);
    }];
    
    for (NSOperation *op in ops) {
        [op2 addDependency:op];
    }
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:op2];
    for (NSOperation *op in ops) {
        [queue addOperation:op];
    }
}
@end
