//
//  XKMsgCenter.h
//  XKKit
//
//  Created by Allen、 LAS on 2018/5/9.
//  Copyright © 2018年 重楼. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XKMsgCenterObserverDelegate;

@interface XKMsgCenter : NSObject

/**
 *  单列
 */
+ (instancetype)shared;

/**
 *  添加消息监听(是异步发送消息，如有ui操作，请再重回主线程)
 *
 *  @param observer 消息监听者
 *  @param type   消息类型
 */
- (void)xk_AddObserver:(id<XKMsgCenterObserverDelegate> __nonnull)observer type:(NSString* __nonnull)type;

/**
 发送消息
 
 @param message 消息类型
 @param parameters 传递的参数
 */
- (void)xk_PostMessage:(NSString* __nonnull)message parameters: (nullable id)parameters;

#pragma mark - NSNotificationCenter  -

/**
 *  添加一个消息监听到通知中心
 *
 *  @param observer  监听者
 *  @param selector  响应方法
 *  @param name      监听的消息
 */
void xk_AddPost(id observer, SEL selector,NSString * name, id _Nullable object);

/**
 *  通过名字删除消息监听
 *
 *  @param observer  监听者
 *  @param name       监听的消息 nil,则清除所有消息
 */
void xk_RemovePost(id observer,NSString * _Nullable name,id _Nullable object);

/**
 *  发送一个消息监听
 *
 *  @param name   监听的名字
 *  @param object 发送的数据，没有就填nil
 */
void xk_Post(NSString * name, id  _Nullable object,NSDictionary* _Nullable userInfo);

@end

//消息协议
@protocol XKMsgCenterObserverDelegate <NSObject>
@required;

/**
 *  接收消息，并响应事件
 *
 *  @param observer   消息类型
 *  @param type 消息类型
 *  @param parameters  传递的参数
 */

- (void)xk_DidReceiveMessageWithObserver:(id)observer type:(NSString*)type parameters:(__nullable id)parameters;

@end

NS_ASSUME_NONNULL_END
