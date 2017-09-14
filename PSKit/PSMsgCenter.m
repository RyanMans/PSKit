//
//  PSMsgCenter.m
//  PSKit
//
//  Created by RyanMans on 2017/8/4.
//  Copyright © 2017年 P.S. All rights reserved.
//

#import "PSMsgCenter.h"
#import "PSThread.h"
//消息对象
@interface PSMsgObject : NSObject
@property (nonatomic,weak,readonly)id object;
@end
@implementation PSMsgObject

+ (PSMsgObject*)shared:(id)object{
    
    return [[PSMsgObject alloc] initWithObject:object];
}

- (instancetype)initWithObject:(id)object
{
    self = [super init];
    if (self) {
        _object = object;
    }
    return self;
}
@end


@interface PSMsgCenter ()
@property (nonatomic,strong)NSMutableDictionary * receiverDicts;  //监听者集合
@end

@implementation PSMsgCenter

+ (instancetype)shareInstance{
    
    static PSMsgCenter * msg = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        msg = [PSMsgCenter new];
    });
    return msg;
}

- (NSMutableDictionary*)receiverDicts{
    
    if (!_receiverDicts) {
        
        _receiverDicts = [[NSMutableDictionary alloc] init];
    }
    return _receiverDicts;
}

//MARK:添加消息
- (void)ps_AddReceiver:(id<PSMsgDispatcherDelegate>)obj type:(NSString *)type{
    
    NSMutableArray * temp = self.receiverDicts[type];
    
    PSMsgObject * object = [PSMsgObject shared:obj];
    
    if (!temp) {
        
        temp = [NSMutableArray arrayWithCapacity:4UL];
        
        [self.receiverDicts setObject:temp forKey:type];
    }
    
    [temp addObject:object];
}

//MARK:发送消息
- (void)ps_SendMessage:(NSString *)msg userParam:(id)param
{
    if ([NSThread isMainThread]) {
        
        runBlockWithAsync(^{
            
            [self ps_SendMessage:msg userParam:param];
        });

        return;
    }
    
    NSMutableArray * temp = self.receiverDicts[msg];
    
    [temp enumerateObjectsUsingBlock:^(PSMsgObject *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id<PSMsgDispatcherDelegate> delegate = obj.object;
        
        [delegate ps_DidReceivedMessage:msg msgDispatcher:obj.object userParam:param];

    }];
}

#pragma mark -NSNotificationCenter-

//添加一个消息监听到通知中心
void ps_AddPost(id observer, SEL selector,NSString * name, id _Nullable object)
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
}

//通过名字删除消息监听
void ps_RemovePost(id observer,NSString * _Nullable name,id _Nullable object){

    if (name.length) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:object];
    }
    else{
        
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}

//发送一个消息监听
void ps_Post(NSString * name, id  _Nullable object,NSDictionary* _Nullable userInfo){
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}

@end
