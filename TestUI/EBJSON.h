//
//  YJBJSON.h
//  YJBOnlineBusiness
//
//  Created by li on 2021/6/1.
//  Copyright © 2021 光大证券股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBJSON : NSObject

+ (BOOL)isValidJSONObject:(id)object;
+ (BOOL)isValidJSONString:(NSString *)string;

+ (NSData *)dataWithString:(NSString *)string;
+ (NSData *)dataWithJSONObject:(id)object;
+ (NSData *)dataWithArray:(NSArray *)array;
+ (NSData *)dataWithDictionary:(NSDictionary *)dictionary;

+ (NSString *)stringWithData:(NSData *)data;
+ (NSString *)stringWithJSONObject:(id)object;
+ (NSString *)stringWithArray:(NSArray *)array;
+ (NSString *)stringWithDictionary:(NSDictionary *)dictionary;

+ (id)JSONObjectWithData:(NSData *)data;
+ (id)JSONObjectWithString:(NSString *)string;

+ (NSArray *)arrayWithData:(NSData *)data;
+ (NSArray *)arrayWithString:(NSString *)string;

+ (NSDictionary *)dictionaryWithData:(NSData *)data;
+ (NSDictionary *)dictionaryWithString:(NSString *)string;

// debug用，打印出一个对象所有的值。@Important 不要在项目中直接使用。
+ (NSString *)stringWithNSObject:(id)object;
+ (id)JSONObjectWithNSObject:(id)object;

@end
