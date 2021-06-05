//
//  EBHttpNetwork.m
//  TestUI
//
//  Created by li on 2021/6/5.
//

#import "EBHttpNetwork.h"

#define kBoundary @"----EBFormBoundary0SOSDK230IQAt0HA7oxwIx3f"
#define KNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]

@interface EBHttpNetwork ()<NSURLSessionDelegate>

@end

@implementation EBHttpNetwork

static EBHttpNetwork *_instance = nil;

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
        
        
    }
    
    return self;
}

#pragma mark -- http multipart/form-data boundary数据的生成

- (void)postFormData:(NSData *)fileData serverFile:(NSString *)serverFileName request:(NSURLRequest *)request
        completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    
    if (!fileData || !request) {
        
        if (completionHandler) {
            
            completionHandler(nil, nil, [NSError errorWithDomain:@"file = nil 或者 request = nil" code:-1 userInfo:nil]);
        }
        
        return;
    }
    
    NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kBoundary];
    
    [mutableURLRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSData *formData = [self httpBoundaryDataFromFile:fileData serverFile:serverFileName];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:[mutableURLRequest copy] fromData:formData completionHandler:completionHandler];
    
    [uploadTask resume];
    
    [session finishTasksAndInvalidate];
}

- (NSData *)httpBoundaryDataFromFile:(NSData *)fileData serverFile:(NSString *)serverFile {
    
    NSMutableData *httpBoundaryMData = [NSMutableData data];
    
    [httpBoundaryMData appendData:[[NSString stringWithFormat:@"--%@", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [httpBoundaryMData appendData:KNewLine];
    
    NSString *destFileName = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"", serverFile];
    
    [httpBoundaryMData appendData:[destFileName dataUsingEncoding:NSUTF8StringEncoding]];
    
    [httpBoundaryMData appendData:KNewLine];
    
    [httpBoundaryMData appendData: [@"Content-Type: application/octet-stream" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [httpBoundaryMData appendData:KNewLine];
    
    [httpBoundaryMData appendData:KNewLine];

    [httpBoundaryMData appendData:fileData];
    
    [httpBoundaryMData appendData:KNewLine];
    
    [httpBoundaryMData appendData:[[NSString stringWithFormat:@"--%@--",kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [httpBoundaryMData copy];
}

@end
