//
//  XKThread.h
//  XKKit
//
//  Created by Allen、 LAS on 2018/5/9.
//  Copyright © 2018年 重楼. All rights reserved.
//

#ifndef XKThread_h
#define XKThread_h

/**
 是否是当前线程
 
 @return yes／no
 */
BOOL isCurrentThread();

/**
 是否是主线程
 
 @return yes／no
 */
BOOL isMainThread();

/**
 *  主线程
 *
 *  @param block  主线程
 */
void xk_RunBlockWithMain(dispatch_block_t block);

/**
 *  异步线程
 *
 *  @param block  异步执行
 */
void xk_RunBlockWithAsync(dispatch_block_t block);

/**
 *  先异步 后同步
 *
 *  @param asyncBlock  异步
 *  @param syncBlock   同步
 */
void xk_RunBlock(dispatch_block_t asyncBlock, dispatch_block_t syncBlock);


/**
 延时后调用，主线程
 
 @param time 时间， 0.5
 @param block 主线程
 
 */
void xk_RunBlockWithAsyncAfter(float time, dispatch_block_t block);


#endif /* XKThread_h */
