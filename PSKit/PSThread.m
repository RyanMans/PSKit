//
//  PSThread.m
//  PSKit
//
//  Created by RyanMans on 2017/8/9.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSThread.h"

//是否是主线程
BOOL isMainThread(){
    
    return [NSThread isMainThread];
}

//主线程
void runBlockWithMain(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

//异步线程
void runBlockWithAsync(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

//先异步 后同步
void runBlock(dispatch_block_t asyncBlock, dispatch_block_t syncBlock)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        asyncBlock();
        dispatch_async(dispatch_get_main_queue(), syncBlock);
    });
}

// 延时后调用，主线程
void runBlockWithAsyncAfter(float time, dispatch_block_t block){
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(),block);
}
