//
//  EBCypto.h
//  TestUI
//
//  Created by li on 2021/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EBCyptor : NSObject

+ (NSData *)ciperWithRC4:(NSData *)data;

+ (NSData *)deciperWithRC4:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
