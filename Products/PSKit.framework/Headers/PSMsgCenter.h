//
//  PSMsgCenter.h
//  PSKit
//
//  Created by RyanMans on 2017/8/4.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define _API_UNAVAILABLE(INFO)    __attribute__((unavailable(INFO)))

#define PSMsgCenterInstance   [PSMsgCenter shareInstance]

@protocol PSMsgDispatcherDelegate;

/**
 消息中心：实现消息传递，消息接收，消息事件响应
 */
@interface PSMsgCenter : NSObject

/**
 *  单列
 */
+ (instancetype)shareInstance;

/**
 *  添加消息监听(是异步发送消息，如有ui操作，请再重回主线程)
 *
 *  @param obj    消息监听者
 *  @param type   消息类型
 */
- (void)ps_AddReceiver:(id<PSMsgDispatcherDelegate> __nonnull)obj type:(NSString * __nonnull)type;


/**
 发送消息

 @param msg 消息类型
 @param param 传递的参数
 */
- (void)ps_SendMessage:(NSString * __nonnull)msg userParam: (nullable id)param;


#pragma mark - NSNotificationCenter  -

/**
 *  添加一个消息监听到通知中心
 *
 *  @param observer  监听者
 *  @param selector  响应方法
 *  @param name      监听的消息
 */
void ps_AddPost(id observer, SEL selector,NSString * name, id _Nullable object);

/**
 *  通过名字删除消息监听
 *
 *  @param observer  监听者
 *  @param name       监听的消息 nil,则清除所有消息
 */
void ps_RemovePost(id observer,NSString * _Nullable name,id _Nullable object);

/**
 *  发送一个消息监听
 *
 *  @param name   监听的名字
 *  @param object 发送的数据，没有就填nil
 */
void ps_Post(NSString * name, id  _Nullable object,NSDictionary* _Nullable userInfo);

@end


/**
 消息协议
 */
@protocol PSMsgDispatcherDelegate <NSObject>
@required;

/**
 *  接收消息，并响应事件
 *
 *  @param type   消息类型
 *  @param observer 消息监听者
 *  @param param  传递的参数
 */
- (void)ps_DidReceivedMessage: (NSString *)type msgDispatcher: (PSMsgCenter *)observer userParam:(__nullable id)param;
@end

NS_ASSUME_NONNULL_END
