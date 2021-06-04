//
//  EBLogManager.m
//  TZYJ_IPhone
//
//  Created by li on 2021/6/1.
//  Copyright © 2021 光大证券股份有限公司. All rights reserved.
//

#import "EBLogAnalyticManager.h"
#import "EBStoreManager.h"
#import "EBThreadSafeArray.h"
#include <zlib.h>
#import "NSData+Compression.h"

@interface EBLogAnalyticManager() <NSURLSessionDelegate>

@property(nonatomic) NSMutableArray<NSDictionary *> *logsArray;
@property(nonatomic) dispatch_queue_t queue;
@property(nonatomic) dispatch_source_t timer;
@property(nonatomic) EBThreadSafeArray<NSString *> *logFiles;

@property(nonatomic) NSURL *uploadUrl;

@end

@implementation EBLogAnalyticManager

static EBLogAnalyticManager *_instance = nil;

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
        
        _logsArray = [NSMutableArray new];
        
        _logFiles = [EBThreadSafeArray new];
        
        _queue = dispatch_queue_create("ebscn_jyg_log_analytic_queue", DISPATCH_QUEUE_SERIAL);
        
        _uploadUrl = [NSURL URLWithString:@"http://10.84.169.68:38888/log/collect/jsonFile/upload2?deviceId=99998&compress=zip"];
        
//        _uploadUrl = [NSURL URLWithString:@"http://10.84.169.68:38888/eventLogSystem/collect/jsonFile/upload?deviceId=1223"];
    }
    
    return self;
}

- (void)run {
    
    [self filterLogs];
    
    [self scheduleLogUploader];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), _queue, ^{
        
        [self uploadLogs];
    });
}

- (void)forceUpdateLogs {
    
    dispatch_async(_queue, ^{
        
        [self uploadLogs];
    });
}

- (void)forceStoreLogs {
    
    dispatch_async(_queue, ^{
        
        [self writeLogToFile];
        
        [self.logsArray removeAllObjects];
    });
}

- (void)scheduleLogUploader {
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
    
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        
        [self uploadLogs];
    });
    
    dispatch_resume(_timer);
}

- (void)filterLogs {
    
    NSArray<NSString *> *totalfileNameArray = [self allFileNamesThatWaitUpload];
    
    NSMutableArray<NSString *> *outdateFiles = [NSMutableArray new];
    
    NSArray *fileNameArray = [self filterFiles:totalfileNameArray outdate:outdateFiles];
    
    [_logFiles resetTo:fileNameArray];
    
    for (NSString *outdateFileName in outdateFiles) {
        
        [[EBStoreManager sharedInstance] removeFile:EBPathKey_SystemLogFile fileName:outdateFileName];
    }
}

- (NSArray<NSString *> *)filterFiles:(NSArray<NSString *> *)fileNames outdate:(NSMutableArray<NSString *> *)outdateFiles {
    
    NSMutableArray<NSString *> *files = [NSMutableArray new];
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd-HH-mm-ss-SSS"];
    
    for (NSString *fileName in fileNames) {
        
        NSDate *date = [self getFileDate:fileName formatter:dateFormat];
        
        if (!date || [now timeIntervalSinceDate:date] >= 7 * 24 * 3600) {
            
            [outdateFiles addObject:fileName];
        }
        else {
            
            [files addObject:fileName];
        }
    }
    
    return [files copy];
}

- (NSDate *)getFileDate:(NSString *)fileName formatter:(NSDateFormatter *)formatter {
    
    NSRange range = [fileName rangeOfString:@".txt"];
    
    if (range.location == NSNotFound) {
        
        return nil;
    }
    
    NSString *date = [fileName substringWithRange:NSMakeRange(0, range.location)];
    
    return [formatter dateFromString:date];
}

- (void)uploadLogs {
    
    [_logFiles forEach:^(NSString *fileName) {
            
        NSData *fileData = [[EBStoreManager sharedInstance] fileData:EBPathKey_SystemLogFile fileName:fileName];
        
        [self compressAndUpload:fileData fileName:fileName];
    }];
}

- (NSData *)compressData:(NSData *)data {
    
    if (@available(iOS 13.0, *)) {

        return [data compressedDataUsingAlgorithm:NSDataCompressionAlgorithmZlib error:nil];
    }
    
    return [self zlibCompressData:data];
}

- (NSData *)zlibCompressData:(NSData *)data {
    
    if (data.length <= 0) {
        
        return nil;
    }
    
    uLongf zipFileDataLen = [data length];
    
    zipFileDataLen = MAX(zipFileDataLen, compressBound(zipFileDataLen));
    
    Bytef *zipFileData = (Bytef *)malloc(zipFileDataLen);
    
    if (zipFileData == NULL) {
        
        return nil;
    }
    
    //压缩数据
    int ret = compress(zipFileData, &zipFileDataLen, [data bytes], [data length]);
    
    if (ret != Z_OK || zipFileDataLen == 0) {
        
        free(zipFileData);
        
        return nil;
    }
    
    //组装压缩数据
    NSData *zipFileNSData = [NSData dataWithBytes:zipFileData length:zipFileDataLen];
    
    //释放内存
    free(zipFileData);
    
    zipFileData = NULL;
    
    return zipFileNSData;
}

- (void)doUpload:(NSData *)fileData success:(void(^)(id))success {
    
    [self uploadData:fileData success:success failure:nil];
}

- (void)compressAndUpload:(NSData *)fileData fileName:(NSString *)fileName {
    
    NSString *abcd = @"abcdabcdabcdabcd";
    
    NSData *data = [abcd dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *zipData = [self compressData:data];
        
    if (zipData.length <= 0) {
        
        return;
    }
    
    [self doUpload:zipData success:^(id resp) {
            
        [[EBStoreManager sharedInstance] removeFile:EBPathKey_SystemLogFile fileName:fileName];
        
        [self.logFiles removeItem:fileName];
    }];
}

- (NSString *)jsonStrWithObj:(id)obj {

    if (![NSJSONSerialization isValidJSONObject:obj]) {
        
        return nil;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)saveToLog:(NSDictionary *)dic {
    
    dispatch_async(_queue, ^{
        
        [self.logsArray addObject:dic];
        
        if (self.logsArray.count > 50) {
            
            [self writeLogToFile];
            
            [self.logsArray removeAllObjects];
        }
    });
}

- (void)writeLogToFile {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss-SSS"];
    
    NSDate *now = [NSDate date];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.txt", [dateFormatter stringFromDate:now]];
    
    [[EBStoreManager sharedInstance] saveToPath:EBPathKey_SystemLogFile fileName:fileName array:_logsArray];
    
    [_logFiles pushBack:fileName];
}

- (void)mockUploadData:(NSData *)data success:(void(^)(id obj))success failure:(void(^)(NSError *error))failure {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        if (success) {
            
            success(nil);
        }
    });
}

- (NSDictionary *)dicFromJsonStr:(NSString *)str {
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    return dic;
}

- (void)uploadData:(NSData *)data success:(void(^)(id obj))success failure:(void(^)(NSError *error))failure {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_uploadUrl];
    
    request.HTTPMethod = @"POST";
    
    request.timeoutInterval = 60;
        
    NSString *boundary = @"-----WebKitFormBoundary7MA4YWxkTrZu0gW";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // http body
    NSMutableData *body = [NSMutableData data];
    
    NSMutableString *headerString = [NSMutableString stringWithFormat:@"\r\n--%@\r\n", boundary];
    
    NSString *type = [NSString stringWithFormat:@"Content-Disposition: form-data;name=\"%@\"; filename=\"%@\"\r\n", @"file", @"logFiles"];
    
    [headerString appendString:type];
    
    [headerString appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
    
    [body appendData:[headerString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
    request.HTTPBody = body;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable respData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *responseString = [[NSString alloc] initWithData:respData encoding:NSUTF8StringEncoding];
        
        NSDictionary *responseDict = [self dicFromJsonStr:responseString];
        
        NSLog(@"%@", responseDict);
        
        if (error) {
            
            NSLog(@"上传失败 %@", error);
            
            if (failure) {
                
                failure(error);
            }
        }
        else {
            
            NSLog(@"上传成功");
            
            if (success) {
                
                success(response);
            }
        }
    }];
    
    [task resume];
}

- (NSArray<NSString *> *)allFileNamesThatWaitUpload {
    
    NSMutableArray *fileList = [[[EBStoreManager sharedInstance] fileListOfPath:EBPathKey_SystemLogFile] mutableCopy];
    
    [fileList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSString *file1 = obj1;
        
        NSString *file2 = obj2;
    
        int ret = strcmp([file1 UTF8String], [file2 UTF8String]);
        
        if (ret == 0) {
            
            return NSOrderedSame;
        }
        
        return ret < 0 ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    return [fileList copy];
}


@end
