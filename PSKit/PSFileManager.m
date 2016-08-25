//
//  PSFileManager.m
//  PSKit
//
//  Created by Ryan_Man on 16/8/25.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSFileManager.h"

@interface PSFileManager ()
{
    NSFileManager * _fm;
}
@property (nonatomic,strong) dispatch_queue_t fmQueue;
@end

@implementation PSFileManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _fm = [NSFileManager defaultManager];
        _fmQueue = dispatch_queue_create("com.Ryan_Man.PSFileManager", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (PSFileManager*)shareInstance
{
    static PSFileManager * _fileManger = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
      
        _fileManger = [[PSFileManager alloc] init];
        
    });
    
    return _fileManger;
}

#pragma mark - Get -

//获取沙盒主目录路径
- (NSString*)ps_GetHomeDirectory
{
    return NSHomeDirectory();
}

//获取Caches目录路径
- (NSString*)ps_GetCachesDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

// 获取documents  下路径
- (NSString*)ps_GetDocumentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject];
}

// 获取temp 目录路径
- (NSString*)ps_GetTemporaryDirectory
{
    return NSTemporaryDirectory();
}

 // 获取 NSBundle资源路径
- (NSString*)ps_GetMainBundlePathForResource:(NSString *)resource ofType:(NSString *)type
{
    return [[NSBundle mainBundle] pathForResource:resource ofType:type];
}

#pragma mark - Appending -

//获取沙盒主目录路径 NSHomeDirectory()下 某文件目录路径
- (NSString*)ps_AppendingHomeDirectory:(NSString*)fileName
{
    return [[self ps_GetHomeDirectory] stringByAppendingPathComponent:fileName];
}

//获取Caches目录路径 NSCachesDirectory[0]，某文件目录路径
- (NSString*)ps_AppendingCachesDirectory:(NSString*)fileName
{
    return [[self ps_GetCachesDirectory] stringByAppendingPathComponent:fileName];
}

//获取Documents目录路径 NSDocumentationDirectory[0]，某文件目录路径
- (NSString*)ps_AppendingDocumentDirectory:(NSString *)fileName
{
    return [[self ps_GetDocumentDirectory] stringByAppendingPathComponent:fileName];
}

//获取temp 目录路径  NSTemporaryDirectory(),某文件目录路径
- (NSString*)ps_AppendingTemporaryDirectory:(NSString *)fileName
{
    return [[self ps_GetTemporaryDirectory] stringByAppendingPathComponent:fileName];
}

#pragma mark - resource -

//获取某路径下的所有子路径名
- (NSArray*)ps_GetSubpathsAtPath:(NSString*)path
{
    if (![self ps_FileExistsAtPath:path]) return nil;
    
    return [_fm subpathsAtPath:path];
}

// 获取文件路径下的二进制数据
- (NSData*)ps_GetContentsAtPath:(NSString *)path
{
    if (![self ps_FileExistsAtPath:path]) return nil;

    return [_fm contentsAtPath:path];
}

//获取某路径文件的size
- (NSUInteger)ps_GetFileSizeWithPath:(NSString *)path
{
    if (![self ps_FileExistsAtPath:path]) return 0;
    
    return (NSUInteger)[[_fm attributesOfItemAtPath:path error:nil] fileSize];
}

//获取某个文件的全部size
- (NSUInteger)ps_GetAllFileSizeWithPath:(NSString *)path
{
    if (![self ps_FileExistsAtPath:path]) return 0;

    __block NSUInteger size = 0;
    
    dispatch_async(self.fmQueue, ^{
        
        NSDirectoryEnumerator *fileEnumerator = [_fm enumeratorAtPath:path];
        for (NSString *fileName in fileEnumerator)
        {
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [_fm attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}


#pragma mark - handle -

//判断路径是否存在
- (BOOL)ps_FileExistsAtPath:(NSString *)path
{
    if ( !path || path.length == 0) return NO;

    return [_fm fileExistsAtPath:path];
}

//创建文件目录
- (BOOL)ps_CreateDirectoryAtPath:(NSString*)path
{
    if ([self ps_FileExistsAtPath:path]) return YES;
    
    return [_fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

//重命名或者移动一个文件（to不能是已存在的）
- (BOOL)ps_MoveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath
{
    if ((srcPath.length && dstPath.length) == NO) return NO;
    
    if (![self ps_FileExistsAtPath:srcPath]) return NO;

    return [_fm moveItemAtPath:srcPath toPath:dstPath error:nil];
}

//重命名或者复制一个文件（to不能是已存在的）
- (BOOL)ps_CopyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath
{
    if ((srcPath.length && dstPath.length) == NO) return NO;

    if (![self ps_FileExistsAtPath:srcPath]) return NO;
    
    return [_fm copyItemAtPath:srcPath toPath:dstPath error:nil];
}

//删除文件
- (BOOL)ps_RemoveItemAtPath:(NSString *)path
{
    if (![self ps_FileExistsAtPath:path]) return YES;

    return [_fm removeItemAtPath:path error:nil];
}

#pragma mark - NSUserDefaults -

//取值NSUserDefaults
- (id)ps_UserDefaultsObjectForkey:(NSString*)defaultName
{
    if (!defaultName || defaultName.length == 0) return nil;

    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

//存值NSUserDefaults
- (void)ps_UserDefaultsSetObject:(id)Object forKey:(NSString *)defaultName
{
    if (!defaultName || defaultName.length == 0) return;

    [[NSUserDefaults standardUserDefaults] setObject:Object forKey:defaultName];
}

//删值 NSUserDefaults
- (void)ps_UserDefaultsRemoveObjectForKey:(NSString *)defaultName
{
    if (!defaultName || defaultName.length == 0) return;

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
}


@end
