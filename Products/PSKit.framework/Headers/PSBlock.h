//
//  PSBlock.h
//  PSKit
//
//  Created by RyanMans on 2017/8/4.
//  Copyright © 2017年 P.S. All rights reserved.
//

#ifndef PSBlock_h
#define PSBlock_h

typedef void(^xk_EmptyBlock)();
typedef void(^xk_BoolBlock)(BOOL response);
typedef void(^xk_ObjectBlock)(id object);
typedef void(^xk_NumberBlock)(NSNumber * object);
typedef void(^xk_IntegerBlock)(NSInteger object);
typedef void(^xk_StringBlock)(NSString * object);
typedef void(^xk_ArrayBlock)(NSArray * object);
typedef void(^xk_DictionaryBlock)(NSDictionary * object);

typedef void(^xk_NetResponeBlock)(id respone, NSError *error, id userParam);
typedef void(^xk_NetDictionaryResponeBlock)(NSDictionary *respone, NSError *error, id userParam);

#endif /* PSBlock_h */
