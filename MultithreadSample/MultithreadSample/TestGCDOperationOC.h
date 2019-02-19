//
//  TestGCDOperationOC.h
//  MultithreadSample
//
//  Created by LonelyFlow on 18/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestGCDOperationOC : NSObject
+ (void) testGCDGroupDependency;
+ (void) testOperationGroupDependency1;
+ (void) testOperationGroupDependency2;
+ (void) testOperationGroupDependency3;
+ (void) testOperationCancleOperationBlock;
@end
