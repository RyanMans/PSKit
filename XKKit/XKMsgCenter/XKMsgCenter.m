//
//  XKMsgCenter.m
//  XKKit
//
//  Created by Allen、 LAS on 2018/5/9.
//  Copyright © 2018年 重楼. All rights reserved.
//

#import "XKMsgCenter.h"
#import "XKThread.h"

@interface XKMsgObject : NSObject
@property (nonatomic,weak,readonly)id object;
@end
@implementation XKMsgObject

+ (XKMsgObject*)shared:(id)object{
    return   [[XKMsgObject alloc] initWithObject:object];
}

- (instancetype)initWithObject:(id)object{
    self = [super init];
    if (self) {
        _object = object;
    }
    return self;
}
@end

@interface XKMsgCenter()
@property(nonatomic,strong)NSMutableDictionary * dataSource;
@end

@implementation XKMsgCenter

//单列
+ (instancetype)shared{
    static XKMsgCenter * temp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        temp = [[XKMsgCenter alloc] init];
    });
    return temp;
}

//数据源
- (NSMutableDictionary*)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableDictionary dictionary];
    }
    return _dataSource;
}

//添加消息监听者
- (void)xk_AddObserver:(id<XKMsgCenterObserverDelegate>)observer type:(NSString *)type{
    
    XKMsgObject * obj = [XKMsgObject shared:observer];
    NSMutableArray * buffer = self.dataSource[type];
    if (!buffer) {
         buffer = [NSMutableArray array];
         self.dataSource[type] = buffer;
    }
    [buffer addObject:obj];
}

//发送消息
- (void)xk_PostMessage:(NSString *)message parameters:(id)parameters{
    
    if (isMainThread()) {
        xk_RunBlockWithAsync(^{
            [self xk_PostMessage:message parameters:parameters];
        });
        return;
    }
    
    NSMutableArray * buffer = self.dataSource[message];

    [buffer enumerateObjectsUsingBlock:^(XKMsgObject *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id<XKMsgCenterObserverDelegate> delegate = obj.object;
        
        [delegate xk_DidReceiveMessageWithObserver:obj.object type:message parameters:parameters];
    }];
}

#pragma mark -NSNotificationCenter-

//添加一个消息监听到通知中心
void xk_AddPost(id observer, SEL selector,NSString * name, id _Nullable object){
     [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
}

//通过名字删除消息监听
void xk_RemovePost(id observer,NSString * _Nullable name,id _Nullable object){
    if (name.length)  [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:object];
    else  [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

//发送一个消息监听
void xk_Post(NSString * name, id  _Nullable object,NSDictionary* _Nullable userInfo){
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}
@end
