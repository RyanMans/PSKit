//
//  PSFileManager.h
//  PSKit
//
//  Created by Ryan_Man on 16/8/25.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _API_UNAVAILABLE(INFO)    __attribute__((unavailable(INFO)))

NS_ASSUME_NONNULL_BEGIN

#define PSFileManagerInstance   [PSFileManager shareInstance]

@interface PSFileManager : NSObject

/**
 *  forbid
 *
 *  @return
 */
+ (instancetype)new _API_UNAVAILABLE("使用shareInstance来获取实例");

/**
 *  单列
 *
 *  @return
 */
+ (PSFileManager*)shareInstance;

#pragma mark - Get -

/**
 *  获取沙盒主目录路径 NSHomeDirectory()
 *
 *  @return 
 */
- (NSString*)ps_GetHomeDirectory;

/**
 *  获取Library目录 NSLibraryDirectory
 *
 *  @return
 */
- (NSString*)ps_GetLibraryDirectory;

/**
 *   获取Caches目录路径 NSCachesDirectory[0]
 *
 *  @return 
 */
- (NSString*)ps_GetCachesDirectory;

/**
 *  获取Documents目录路径 NSDocumentationDirectory[0]
 *
 *  @return 
 */
- (NSString*)ps_GetDocumentDirectory;

/**
 *  获取temp 目录路径  NSTemporaryDirectory()(会多 ‘／’，系统自带)
 *
 *  @return
 */
- (NSString*)ps_GetTemporaryDirectory;

/**
 *  获取NSBundle 下资源路径
 *
 *  @param resource 资源名称
 *  @param type     资源类型
 *
 *  @return
 */
- (nullable NSString*)ps_GetMainBundlePathForResource:(NSString*)resource ofType:(NSString*)type;

#pragma mark - Appending -

/**
 *  获取沙盒主目录路径 NSHomeDirectory()下 某文件目录路径
 *
 *  @param fileName 文件名称
 *
 *  @return
 */
- (nullable NSString*)ps_AppendingHomeDirectory:(NSString*)fileName;

/**
 *  获取Caches目录路径 NSCachesDirectory[0]，某文件目录路径
 *
 *  @param fileName 文件名称
 *
 *  @return
 */
- (nullable NSString*)ps_AppendingCachesDirectory:(NSString*)fileName;

/**
 * 获取Documents目录路径 NSDocumentationDirectory[0]，某文件目录路径
 *
 *  @param fileName 文件名称
 *
 *  @return
 */
- (nullable NSString*)ps_AppendingDocumentDirectory:(NSString*)fileName;

#pragma mark - resource -

/**
 *  获取某路径下的所有子路径名
 *
 *  @param path 文件路径
 *
 *  @return
 */
- (nullable NSArray*)ps_GetSubpathsAtPath:(NSString*)path;

/**
 *  获取文件路径下的二进制数据
 *
 *  @param path 文件路径
 *
 *  @return
 */
- (nullable NSData*)ps_GetContentsAtPath:(NSString*)path;

/**
 *  获取某路径文件的size
 *
 *  @param path 文件路径
 *
 *  @return
 */
- (NSUInteger)ps_GetFileSizeWithPath:(NSString*)path;

/**
 * 获取某个文件的全部size
 *
 *  @param path
 *
 *  @return
 */
- (NSUInteger)ps_GetAllFileSizeWithPath:(NSString *)path;

#pragma mark - handle -

/**
 *  判断路径是否存在
 *
 *  @param path
 *
 *  @return
 */
- (BOOL)ps_FileExistsAtPath:(NSString*)path;

/**
 *  创建文件目录目录
 *
 *  @param path 文件路径
 *
 *  @return
 */
- (BOOL)ps_CreateDirectoryAtPath:(NSString*)path;

/**
 *  重命名或者移动一个文件（to不能是已存在的）
 *
 *  @param srcPath
 *  @param dstPath
 *
 *  @return 
 */
- (BOOL)ps_MoveItemAtPath:(NSString*)srcPath toPath:(NSString *)dstPath;

/**
 *  重命名或者复制一个文件（to不能是已存在的）
 *
 *  @param srcPath
 *  @param dstPath
 *
 *  @return
 */
- (BOOL)ps_CopyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

/**
 *  删除文件
 *
 *  @param path
 *
 *  @return
 */
- (BOOL)ps_RemoveItemAtPath:(NSString*)path;

#pragma mark - NSUserDefaults -

/**
 *  取值 NSUserDefaults
 *
 *  @param defaultName 
 *
 *  @return 
 */
- (nullable id)ps_UserDefaultsObjectForkey:(NSString*)defaultName;

/**
 *  存值 NSUserDefaults
 *
 *  @param Object
 *  @param defaultName
 */
- (void)ps_UserDefaultsSetObject:(id)Object forKey:(NSString *)defaultName;

/**
 *  删值 NSUserDefaults
 *
 *  @param defaultName
 */
- (void)ps_UserDefaultsRemoveObjectForKey:(NSString*)defaultName;

@end
NS_ASSUME_NONNULL_END