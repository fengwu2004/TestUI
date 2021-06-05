//
//  EBStoreManager.m
//  TZYJ_IPhone
//
//  Created by li on 2021/6/1.
//  Copyright © 2021 光大证券股份有限公司. All rights reserved.
//

#import "EBStoreManager.h"
#include <mutex>

@interface EBPathSetting() {
    
@public
    std::mutex mux;
}

@end


@implementation EBPathSetting

+ (id)pathFrom:(NSString *)path fileName:(NSString *)fileName {
    
    EBPathSetting *setting = [EBPathSetting new];
    
    setting.path = path;
    
    setting.fileName = fileName;
    
    return setting;
}

+ (NSString *)libPath {
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    if (array.count > 0) {
        
        return array[0];
    }
    
    return nil;
}

- (NSString *)absPath {
    
    NSString *directoryPath = [self.class libPath];
    
    if (!directoryPath) {
        
        return nil;
    }
    
    if (_fileName.length > 0) {
        
        return [directoryPath stringByAppendingFormat:@"%@%@", _path, _fileName];
    }
    else {
        
        return [directoryPath stringByAppendingFormat:@"%@", _path];
    }
}

- (BOOL)isDirectory {
    
    return _fileName.length == 0;
}

@end

//----------------------------------------------------------------------------------------------------------

@interface EBStoreManager()

@property(nonatomic) NSDictionary<NSNumber *, EBPathSetting *> *pathSettings;

@end


@implementation EBStoreManager

static EBStoreManager *_instance = nil;

+ (id)sharedInstance {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _instance = [[super allocWithZone:NULL] initPrivate];
    });
    
    return _instance;
}

- (id)init {
    
    return self;
}

- (instancetype)copyWithZone:(struct _NSZone *)zone {
    
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [self sharedInstance];
}

- (id)initPrivate {
    
    self = [super init];
    
    if (self) {
        
        _pathSettings = @{
            
            @(EBPathKey_SystemLogFile):[EBPathSetting pathFrom:@"/systemlog/" fileName:nil],
            @(EBPathKey_SystemCrashFile):[EBPathSetting pathFrom:@"/systemcreash/" fileName:nil],
        };
    }
    
    return self;
}

- (NSData *)jsonStrWithObj:(id)obj {

    if (![NSJSONSerialization isValidJSONObject:obj]) {
        
        return nil;
    }
    
    return [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
}

- (void)appendToPath:(EBPathKey)path fileName:(NSString *)fileName data:(NSData *)data {
    
    if (data.length <= 0) {
        
        return;
    }
    
    EBPathSetting *pathSetting = _pathSettings[@(path)];
    
    if (!pathSetting) {
        
        return;
    }
    
    NSString *absPath = [pathSetting absPath];
    
    if (![pathSetting isDirectory]) {
        
        return;
    }
    
    [[NSFileManager defaultManager] createDirectoryAtPath:absPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    NSString *filePath = [absPath stringByAppendingString:fileName];
    
    std::lock_guard<std::mutex> lk(pathSetting->mux);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        
        [fileHandle seekToEndOfFile];
        
        [fileHandle writeData:data];
        
        [fileHandle closeFile];
    }
    else {
        
        if ([data writeToFile:filePath atomically:YES]) {
            
            NSLog(@"写入成功 %@", filePath);
        }
        else {
            
            NSLog(@"写入失败 %@", filePath);
        }
    }
}

- (void)saveToPath:(EBPathKey)path fileName:(NSString *)fileName data:(NSData *)data {
    
    EBPathSetting *pathSetting = _pathSettings[@(path)];
    
    if (!pathSetting) {
        
        return;
    }
    
    NSString *absPath = [pathSetting absPath];
    
    if (![pathSetting isDirectory]) {
        
        return;
    }
    
    [[NSFileManager defaultManager] createDirectoryAtPath:absPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    NSString *filePath = [absPath stringByAppendingString:fileName];
        
    std::lock_guard<std::mutex> lk(pathSetting->mux);
    
    if ([data writeToFile:filePath atomically:YES]) {
        
//        NSLog(@"写入成功 %@", filePath);
    }
    else {
        
//        NSLog(@"写入失败 %@", filePath);
    }
}

- (void)saveToPath:(EBPathKey)path fileName:(NSString *)fileName array:(NSArray *)array {
    
    NSData *data = [self jsonStrWithObj:array];
    
    [self saveToPath:path fileName:fileName data:data];
}

- (NSArray<NSString *> *)fileListOfPath:(EBPathKey)path {
    
    EBPathSetting *pathSetting = _pathSettings[@(path)];
    
    if (!pathSetting) {
        
        return nil;
    }
    
    NSString *absPath = [pathSetting absPath];
    
    BOOL isDir = [pathSetting isDirectory];
    
    if (isDir) {
            
        std::lock_guard<std::mutex> lk(pathSetting->mux);
        
        return [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:absPath error:nil] mutableCopy];
    }
    
    if (absPath.length > 0) {
        
        return @[absPath];
    }
    
    return nil;
}

- (NSData *)fileData:(EBPathKey)path fileName:(NSString *)fileName {
    
    EBPathSetting *pathSetting = _pathSettings[@(path)];
    
    if (!pathSetting) {
        
        return nil;
    }
    
    NSString *absPath = [pathSetting absPath];
    
    NSString *filePath = [absPath stringByAppendingString:fileName];
    
    std::lock_guard<std::mutex> lk(pathSetting->mux);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        return nil;
    }
    
    return [NSData dataWithContentsOfFile:filePath];
}

- (void)removeFile:(EBPathKey)path fileName:(NSString *)fileName {
    
    EBPathSetting *pathSetting = _pathSettings[@(path)];
    
    if (!pathSetting) {
        
        return;
    }
    
    NSString *absPath = [pathSetting absPath];
    
    BOOL isDir = [pathSetting isDirectory];
    
    if (!isDir) {
            
        return;
    }
    
    NSString *filePath = [absPath stringByAppendingString:fileName];
    
    std::lock_guard<std::mutex> lk(pathSetting->mux);
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

@end
