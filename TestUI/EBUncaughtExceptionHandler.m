//
//  UncaughtExceptionHandler.m
//  UncaughtExceptionHandler
//
//  Created by li on 2021/6/1.
//  Copyright © 2021 光大证券股份有限公司. All rights reserved.

#import "EBUncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "EBStoreManager.h"

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

void HandleException(NSException *exception);

void SignalHandler(int signal);

NSString* getAppInfo(void) {
    
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion];
    return appInfo;
}


@interface EBUncaughtExceptionHandler()

@property (assign, nonatomic) BOOL dismissed;
@end

@implementation EBUncaughtExceptionHandler

+ (void)installUncaughtExceptionHandler {
    
    NSSetUncaughtExceptionHandler(HandleException);
    
    signal(SIGABRT, SignalHandler);
    
    signal(SIGILL, SignalHandler);
    
    signal(SIGSEGV, SignalHandler);
    
    signal(SIGFPE, SignalHandler);
    
    signal(SIGBUS, SignalHandler);
    
    signal(SIGPIPE, SIG_IGN);// 该信号忽略以减少闪退几率
}

+ (void)uploadCrashLogFile {
    
    NSArray<NSString *> *fileList = [[[EBStoreManager sharedInstance] fileListOfPath:EBPathKey_SystemCrashFile] copy];
    
    for (NSString *fileName in fileList) {
        
        NSData *fileData = [[EBStoreManager sharedInstance] fileData:EBPathKey_SystemCrashFile fileName:fileName];
        
        
    }
}

+ (void)removeCrashFile:(NSString *)path {
    
    BOOL fileExists = NO;
    
    BOOL isDirectory = NO;
    
    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (fileExists && !isDirectory) {
        
        NSError *error = nil;
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        
        if (error) {
            
            NSLog(@"删除崩溃文件出错");
        }
    }
}

//获取调用堆栈
+ (NSArray *)backtrace {
    
    //指针列表
    void* callstack[128];
    //backtrace用来获取当前线程的调用堆栈，获取的信息存放在这里的callstack中
    //128用来指定当前的buffer中可以保存多少个void*元素
    //返回值是实际获取的指针个数
    int frames = backtrace(callstack, 128);
    //backtrace_symbols将从backtrace函数获取的信息转化为一个字符串数组
    //返回一个指向字符串数组的指针
    //每个字符串包含了一个相对于callstack中对应元素的可打印信息，包括函数名、偏移地址、实际返回地址
    char **strs = backtrace_symbols(callstack, frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (int i = 0; i < frames; i++) {
        
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    
    free(strs);
    
    return backtrace;
}

void logToFile(NSString *logName, NSString *message, ...) {
    
    if (!logName || logName.length == 0) {
        
        return;
    }
    
    va_list argList;
    
    va_start(argList, message);
    
    NSString *formattedMessage = [[NSString alloc] initWithFormat:message arguments:argList];
    
    va_end(argList);
    
    [[EBStoreManager sharedInstance] saveToPath:EBPathKey_SystemCrashFile fileName:logName data:[formattedMessage dataUsingEncoding:NSUTF8StringEncoding]];
}

//处理报错信息
- (void)validateAndSaveCriticalApplicationData:(NSException *)exception {
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"appInfo:\n%@\n\nexceptionName:%@\nexceptionReason:%@\nexceptionUserInfo:%@\ncallStackSymbols:%@\n", getAppInfo(),exception.name, exception.reason, exception.userInfo ? : @"no user info", [exception callStackSymbols]?:@""];
    
    time_t t = time(NULL);
    
    struct tm *tm = localtime(&t);
    
    NSString *timeString = [NSString stringWithFormat:@"%@_%04d_%02d_%02d_%02dH%02dM%02dS.txt", [self appVersion], tm->tm_year+1900, tm->tm_mon+1, tm->tm_mday, tm->tm_hour, tm->tm_min, tm->tm_sec];
    
    logToFile(timeString, exceptionInfo);
}

- (NSString *)appVersion {
    
    return @"6.0.4.1";
}

- (void)handleException:(NSException *)exception {
    
    [self validateAndSaveCriticalApplicationData:exception];
        
    NSSetUncaughtExceptionHandler(NULL);
    
    signal(SIGABRT, SIG_DFL);
    
    signal(SIGILL, SIG_DFL);
    
    signal(SIGSEGV, SIG_DFL);
    
    signal(SIGFPE, SIG_DFL);
    
    signal(SIGBUS, SIG_DFL);
    
    signal(SIGPIPE, SIG_IGN);// 该信号忽略以减少闪退几率
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
        
    } else {
        
        [exception raise];
    }
}

@end

void HandleException(NSException *exception) {
    
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    // 如果太多不用处理
    if (exceptionCount > UncaughtExceptionMaximum) {
        
        return;
    }
    
    //获取调用堆栈
    NSArray *callStack = [exception callStackSymbols];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    
    NSException *excep = [NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo];
    
    //在主线程中，执行制定的方法, withObject是执行方法传入的参数
    [[[EBUncaughtExceptionHandler alloc] init] performSelectorOnMainThread:@selector(handleException:) withObject:excep waitUntilDone:YES];
}

//处理signal报错
void SignalHandler(int signal) {
    
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    // 如果太多不用处理
    if (exceptionCount > UncaughtExceptionMaximum) {
        
        return;
    }
    
    NSString* description = nil;
    switch (signal) {
        case SIGABRT:
            description = [NSString stringWithFormat:@"Signal SIGABRT was raised!\n"];
            break;
        case SIGILL:
            description = [NSString stringWithFormat:@"Signal SIGILL was raised!\n"];
            break;
        case SIGSEGV:
            description = [NSString stringWithFormat:@"Signal SIGSEGV was raised!\n"];
            break;
        case SIGFPE:
            description = [NSString stringWithFormat:@"Signal SIGFPE was raised!\n"];
            break;
        case SIGBUS:
            description = [NSString stringWithFormat:@"Signal SIGBUS was raised!\n"];
            break;
        case SIGPIPE:
            description = [NSString stringWithFormat:@"Signal SIGPIPE was raised!\n"];
            break;
        default:
            description = [NSString stringWithFormat:@"Signal %d was raised!", signal];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    NSArray *callStack = [EBUncaughtExceptionHandler backtrace];
    
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    
    [userInfo setObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    
    //在主线程中，执行指定的方法, withObject是执行方法传入的参数
    NSException *excep = [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason: description userInfo: userInfo];
    
    [[[EBUncaughtExceptionHandler alloc] init] performSelectorOnMainThread:@selector(handleException:) withObject:excep waitUntilDone:YES];
}
