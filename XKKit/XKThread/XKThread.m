//
//  XKThread.m
//  XKKit
//
//  Created by Allen、 LAS on 2018/5/9.
//  Copyright © 2018年 重楼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKThread.h"

//是否是当前线程
BOOL isCurrentThread(){
    return [NSThread currentThread];
}

//是否是主线程
BOOL isMainThread(){
    return [NSThread isMainThread];
}

//主线程
void xk_RunBlockWithMain(dispatch_block_t block){
    dispatch_async(dispatch_get_main_queue(), block);
}

//异步线程
void xk_RunBlockWithAsync(dispatch_block_t block){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

//先异步 后同步
void xk_RunBlock(dispatch_block_t asyncBlock, dispatch_block_t syncBlock){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (asyncBlock) asyncBlock();
        
        dispatch_async(dispatch_get_main_queue(), syncBlock);
        
    });
}

// 延时后调用，主线程
void xk_RunBlockWithAsyncAfter(float time, dispatch_block_t block){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}
