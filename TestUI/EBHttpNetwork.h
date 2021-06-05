//
//  EBHttpNetwork.h
//  TestUI
//
//  Created by li on 2021/6/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EBHttpNetwork : NSObject

+ (instancetype)sharedInstance;

- (void)postFormData:(NSData *)fileData serverFile:(NSString *)serverFileName request:(NSURLRequest *)request
completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
