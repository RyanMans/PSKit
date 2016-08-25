//
//  PSMsgCenter.m
//  PSKit
//
//  Created by Ryan_Man on 16/8/25.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSMsgCenter.h"

@interface PSMsgObject : NSObject
@property (nonatomic,weak,readonly)id object;
@end

@implementation PSMsgObject

- (instancetype)initWithObject:(id)object
{
    self = [super init];
    if (self) {
        _object = object;
    }
    return self;
}

+ (instancetype)shared:(id)object
{
    PSMsgObject * obj = [[self alloc] initWithObject:object];
    return obj;
}
@end


@interface PSMsgCenter ()
{
    NSMutableDictionary *_msgTree;
    
    NSMutableDictionary *_receivers;
}
@end
@implementation PSMsgCenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _msgTree = [@{} mutableCopy];
        
        _receivers = [@{} mutableCopy];
    }
    return self;
}

+ (instancetype)shareInstance
{
    static PSMsgCenter * _msgCenter = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _msgCenter  = [[PSMsgCenter alloc] init];
    });
    
    return _msgCenter;
}

#pragma mark - PSMsg  -

//群发消息
- (void)ps_SendMessage:(NSString *)msg userParam:(id)param
{
    
    [self  ps_DispatchMessageAsync:msg userParam:param];
    
    //支持群发
    NSArray * temp = _msgTree[msg];
    
    if (temp.count)
    {
        for (NSString * key in temp)
        {
            [self  ps_SendMessage:key userParam:param];
        }
    }
}

//发送单条消息
- (void)ps_DispatchMessageAsync:(NSString *)msg userParam:(id)param
{
    runBlockWithAsync(^{[self ps_DispatchMessage:msg userParam:param];});
}

- (void)ps_DispatchMessage: (NSString *)msg userParam: (nullable id)param
{
    NSMutableArray *temp = _receivers[msg];
    
    if (nil == temp) return;
    
    for (PSMsgObject * ps in temp)
    {
        id<PSMsgDispatcherDelegate> obj = ps.object;
        [obj ps_DidReceivedMessage:msg msgDispatcher:self userParam:param];
    }
}

//添加监听者
- (BOOL)ps_AddReceiver:(id<PSMsgDispatcherDelegate>)obj type:(NSString *)type
{
    
    NSMutableArray * temp = _receivers[type];
    
    if (nil == temp)
    {
        temp = [[NSMutableArray alloc] initWithCapacity:4UL];
        
        [_receivers setObject:temp forKey:type];
    }
    [temp addObject:[PSMsgObject shared:obj]];
    
    return YES;
}

#pragma mark -NSNotificationCenter-

void ps_AddPost(id observer, SEL selector,NSString *name)
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:nil];
}

void ps_RemovePost(id observer,NSString *name)
{
    if (name == nil || name.length == 0)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    else{
        [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:nil];
    }
}

void ps_Post(NSString *name,id object)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

#pragma mark - GCD Thread -

void runBlockWithMain(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

void runBlockWithAsync(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

void runBlock(dispatch_block_t asyncBlock, dispatch_block_t syncBlock)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        asyncBlock();
        dispatch_async(dispatch_get_main_queue(), syncBlock);
    });
}
@end
