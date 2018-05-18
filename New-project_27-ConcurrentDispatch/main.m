//
//  main.m
//  New-project_27-ConcurrentDispatch
//
//  Created by Geraint on 2018/5/17.
//  Copyright © 2018年 kilolumen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//
typedef void (^ComputeTask)(void);

// 检索用于下载URL的语句块
ComputeTask getComputeTask(NSInteger *result, NSUInteger computation) {
    NSInteger *computeResult = result;
    NSUInteger computations = computation;
    
    return ^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"Performing %ld compputations", computations);
        for (int ii = 0; ii < computations; ii++) {
            *computeResult = *computeResult + 1;
        }
    };
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        NSInteger computeResult;
        
        // 创建顺序队列和分组
        dispatch_queue_t serialQueue = dispatch_queue_create("MySerialQueue", DISPATCH_QUEUE_SERIAL);
        // 分组
        dispatch_group_t group = dispatch_group_create();
        
        // 向队列中添加任务（异步方式分派了三个串行执行任务）
        // *** GCD函数dispatch_group_async() 会使这些任务以异步方式执行，因为该队列是一个串行队列。
        dispatch_group_async(group, serialQueue, getComputeTask(&computeResult, 5));
        dispatch_group_async(group, serialQueue, getComputeTask(&computeResult, 10));
        dispatch_group_async(group, serialQueue, getComputeTask(&computeResult, 20));
        
        // 等待，当分组中的所有任务都完成时显示结果
        // *** GCD函数dispatch_group_wait() 被用于阻塞主线程，知道所有任务完成。
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        NSLog(@"Computation result = %ld", computeResult);
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
