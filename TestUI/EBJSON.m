//
//  YJBJSON.m
//  YJBOnlineBusiness
//
//  Created by li on 2021/6/1.
//  Copyright © 2021 光大证券股份有限公司. All rights reserved.
//

#import "EBJSON.h"
#import <objc/runtime.h>

@implementation EBJSON

#pragma mark - is valid

+ (BOOL)isValidJSONObject:(id)object
{
    return [NSJSONSerialization isValidJSONObject:object];
}

+ (BOOL)isValidJSONString:(NSString *)string
{
    id obj = [self JSONObjectWithString:string];
    if ([self isValidJSONObject:obj]) {
        return YES;
    }
    return NO;
}

#pragma mark - to data

+ (NSData *)dataWithString:(NSString *)string
{
    if (!string) {
        return nil;
    }
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

+ (NSData *)dataWithJSONObject:(id)object
{
    if (!object) {
        
        return nil;
    }
    
    if (![NSJSONSerialization isValidJSONObject:object]) {
        
        return nil;
    }
    
    NSError *error = nil;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:object
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if (error) {
        
        return nil;
    }
    
    return data;
}

+ (NSData *)dataWithArray:(NSArray *)array
{
    return [EBJSON dataWithJSONObject:array];
}

+ (NSData *)dataWithDictionary:(NSDictionary *)dictionary
{
    return [EBJSON dataWithJSONObject:dictionary];
}

#pragma mark - to string

+ (NSString *)stringWithData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    
    NSString *string = nil;
    
    @try {
        
        string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    } @catch (NSException *exception) {
        
        NSLog(@"%@", exception);
        
    } @finally {
        
        
    }

#if __has_feature(objc_arc)
    return string;
#else
    return [string autorelease];
#endif
}

+ (NSString *)stringWithJSONObject:(id)object
{
    NSData *data = [EBJSON dataWithJSONObject:object];
    
    if (!data) {
        return nil;
    }
    
    return [self stringWithData:data];
}

+ (NSString *)stringWithArray:(NSArray *)array
{
    return [EBJSON stringWithJSONObject:array];
}

+ (NSString *)stringWithDictionary:(NSDictionary *)dictionary
{
    return [EBJSON stringWithJSONObject:dictionary];
}

#pragma mark - to json object

+ (id)JSONObjectWithData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    
    NSError *error = nil;
    id obj = [self JSONSafeNSNullObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                          error:&error];
    
    if (!obj || error) {
        return nil;
    }
    return obj;
}

+ (id)JSONObjectWithString:(NSString *)string
{
    NSData *data = [EBJSON dataWithString:string];
    if (!data) {
        return nil;
    }
    return [EBJSON JSONObjectWithData:data];
}

#pragma mark - to array

+ (NSArray *)arrayWithData:(NSData *)data
{
    return [EBJSON JSONObjectWithData:data];
}

+ (NSArray *)arrayWithString:(NSString *)string
{
    return [EBJSON JSONObjectWithString:string];
}

#pragma mark - to dictionary

+ (NSDictionary *)dictionaryWithData:(NSData *)data
{
    return [EBJSON JSONObjectWithData:data];
}

+ (NSDictionary *)dictionaryWithString:(NSString *)string
{
    return [EBJSON JSONObjectWithString:string];
}

#pragma mark - object to JSONObject, for debug

+ (NSString *)stringWithNSObject:(id)object
{
    return [self stringWithJSONObject:[self JSONObjectWithNSObject:object]];
}

+ (id)JSONObjectWithNSObject:(id)object
{
    if ([self isSystemClass:[object class]]) {
        if ([object isKindOfClass:[NSArray class]]
            || [object isKindOfClass:[NSSet class]]
            || [object isKindOfClass:[NSDictionary class]]) {
            return [self systemValueWithNSObject:object];
        }
        return @{NSStringFromClass([object class]) : [self systemValueWithNSObject:object]};
    }
    
    NSMutableDictionary *dict = @{}.mutableCopy;
    Class cls = [object class];
    while (cls) {
        [dict addEntriesFromDictionary:[self dictionaryWithNSObject:object class:cls]];
        cls = class_getSuperclass(cls);
    }
    return dict;
}

+ (NSDictionary *)dictionaryWithNSObject:(id)object class:(Class)cls
{
    NSMutableDictionary *dict = @{}.mutableCopy;
    
    unsigned int count = 0;
    Ivar *header = class_copyIvarList(cls, &count);
    Ivar *list = header;
    for (int i = 0; i < count; i++) {
        Ivar ivar = *list++;
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = [self valueWithNSObject:object ivar:ivar] ? : [NSNull null];
        dict[name] = value;
    }
    free(header);
    return dict;
}

+ (id)valueWithNSObject:(id)object ivar:(Ivar)ivar
{
    const char *encoding = ivar_getTypeEncoding(ivar);
    if (strlen(encoding) < 1) {
        return nil;
    }
    
    ptrdiff_t offset = ivar_getOffset(ivar);
    if (offset == 0) {
        return NSStringFromClass([object class]);
    }
    
    id value = nil;
    const char encoding0 = ivar_getTypeEncoding(ivar)[0];
    switch (encoding0) {
        case 'c':
        {value = @(((char (*)(id, Ivar))object_getIvar)(object, ivar));}
            break;
        case 'i':
        {value = @(((int (*)(id, Ivar))object_getIvar)(object, ivar));}
            break;
        case 's':
        {value = @(((short (*)(id, Ivar))object_getIvar)(object, ivar));}
            break;
        case 'l':
        {value = @(((long (*)(id, Ivar))object_getIvar)(object, ivar));}
            break;
        case 'q':
        {value = @(((long long (*)(id, Ivar))object_getIvar)(object, ivar));}
            break;
        case 'C':
        {value = @(((unsigned char (*)(id, Ivar))object_getIvar)(object, ivar));}
            break;
        case 'I':
        {value = @(((unsigned int (*)(id, Ivar))object_getIvar)(object, ivar));}
            break;
        case 'S':
        {value = @(((unsigned short (*)(id, Ivar))object_getIvar)(object, ivar));}
            break;
        case 'L':
        {value = @(((unsigned long (*)(id, Ivar))object_getIvar)(object, ivar));}
            break;
        case 'Q':
        {value = @(((unsigned long long (*)(id, Ivar))object_getIvar)(object, ivar));}
            break;
        case 'f':
        {value = @(*(float *)((ptrdiff_t)object + offset));}
            break;
        case 'd':
        {value = @(*(double *)((ptrdiff_t)object + offset));}
            break;
        case 'B':
        {value = @(((bool (*)(id, Ivar))object_getIvar)(object, ivar));}
            break;
        case 'v':
        {value = @"void";}
            break;
        case '*':
        {{value = @(((char * (*)(id, Ivar))object_getIvar)(object, ivar));}}
            break;
        case '@':
        {value = [self nsObjectValueFromOriginValue:object_getIvar(object, ivar)];}
            break;
        case '#':
        {value = NSStringFromClass(object_getIvar(object, ivar));}
            break;
        case ':':
        {value = NSStringFromSelector(((SEL (*)(id, Ivar))object_getIvar)(object, ivar));}
            break;
        case '[': // object_getIvar(object, ivar) returns nil, should use ptrdiff_t address = (ptrdiff_t)object + offset; to get value
        {value = @"An array";}
            break;
        case '{':
        {value = @"An struct";}
            break;
        case '(':
        {value = @"A union";}
            break;
        case 'b':
        {value = @"A bit field of num bits";}
            break;
        case '^':
        {value = @"A pointer to type";}
            break;
        case '?':
        {value = @"An unknown type";}
            break;
        default:
        {value = @"An unkown type not supported";}
            break;
    }
    return value;
}

+ (id)systemValueWithNSObject:(id)originValue
{
    id value = nil;
    if ([originValue isKindOfClass:[NSString class]]
        || [originValue isKindOfClass:[NSNumber class]]) {
        value = originValue;
    }
    else if ([originValue isKindOfClass:[NSArray class]]
             || [originValue isKindOfClass:[NSSet class]]) {
        if ([NSJSONSerialization isValidJSONObject:originValue]) {
            value = originValue;
        }
        else {
            value = @[].mutableCopy;
            for (id item in (NSArray *)originValue) {
                [value addObject:[self nsObjectValueFromOriginValue:item]];
            }
        }
    }
    else if ([originValue isKindOfClass:[NSDictionary class]]) {
        if ([NSJSONSerialization isValidJSONObject:originValue]) {
            value = originValue;
        }
        else {
            value = @{}.mutableCopy;
            for (id key in [(NSDictionary *)originValue allKeys]) {
                [value setObject:[self nsObjectValueFromOriginValue:originValue[key]]
                          forKey:[key description]];
            }
        }
    }
    else {
        value = [originValue description];
    }
    return value;
}

+ (id)nsObjectValueFromOriginValue:(id)originValue
{
    id value = nil;
    if ([self isSystemClass:[originValue class]]) {
        value = [self systemValueWithNSObject:originValue];
    }
    else {
        value = [self JSONObjectWithNSObject:originValue];
    }
    return value;
}

+ (BOOL)isSystemClass:(Class)cls
{
    NSBundle *mainB = [NSBundle bundleForClass:cls];
    if (mainB == [NSBundle mainBundle]) {
        return NO;
    }
    return YES;
}

#pragma mark - save to null

+ (nullable id)JSONSafeNSNullObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error
{
    id ret = [NSJSONSerialization JSONObjectWithData:data options:opt error:error];
    
    if ([ret isKindOfClass:[NSDictionary class]]
        ||
        [ret isKindOfClass:[NSMutableDictionary class]])           //如果是NSDictionary
    {
        ret = [self removeObjectsForNSNullKeysFromDictionary:ret];
    }
    else if ([ret isKindOfClass:[NSArray class]]
             ||
             [ret isKindOfClass:[NSMutableArray class]])           //如果是NSArray
    {
        ret = [self removeObjectsForNSNullKeysFromArray:ret];
    }
    return ret;
}

+ (NSDictionary *)removeObjectsForNSNullKeysFromDictionary:(NSDictionary *)dictionary
{
    NSDictionary *ret = dictionary;
    NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
    
    //第一步：处理所有的NSNull元素
    NSMutableArray *nsnullKeyMutableArray = [[NSMutableArray alloc] init];
    for (id key in [mutableDictionary allKeys])
    {
        if ([mutableDictionary[key] isKindOfClass:[NSNull class]])
        {
            [nsnullKeyMutableArray addObject:key];
        }
    }
    [mutableDictionary removeObjectsForKeys:nsnullKeyMutableArray];
    
    //第二步：处理所有的NSArray元素
    for (id key in [mutableDictionary allKeys])
    {
        if ([mutableDictionary[key] isKindOfClass:[NSArray class]]
            ||
            [mutableDictionary[key] isKindOfClass:[NSMutableArray class]])
        {
            NSArray *newArray = [self removeObjectsForNSNullKeysFromArray:mutableDictionary[key]];
            [mutableDictionary setObject:newArray forKey:key];
        }
    }
    
    //第三步：处理所有的NSDictionary元素
    for (id key in [mutableDictionary allKeys])
    {
        if ([mutableDictionary[key] isKindOfClass:[NSDictionary class]]
            ||
            [mutableDictionary[key] isKindOfClass:[NSMutableDictionary class]])
        {
            NSDictionary *newDictionary = [self removeObjectsForNSNullKeysFromDictionary:mutableDictionary[key]];
            [mutableDictionary setObject:newDictionary forKey:key];
        }
    }
    
    ret = [mutableDictionary copy];
    return ret;
}

+ (NSArray *)removeObjectsForNSNullKeysFromArray:(NSArray *)array
{
    NSMutableArray *ret = [array mutableCopy];
    
    
    //第一步：处理所有的NSNull元素
    NSMutableArray *nsnullObjectMutableArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[ret count]; i++)
    {
        id arrayItem = ret[i];
        if ([arrayItem isKindOfClass:[NSNull class]])
        {
            [nsnullObjectMutableArray addObject:arrayItem];
        }
    }
    [ret removeObjectsInArray:nsnullObjectMutableArray];
    
    
    //第二步：处理所有的NSArray元素
    for (int i=0; i<[ret count]; i++)
    {
        id arrayItem = ret[i];
        if ([arrayItem isKindOfClass:[NSArray class]]
            ||
            [arrayItem isKindOfClass:[NSMutableArray class]])
        {
            [ret replaceObjectAtIndex:i withObject:[self removeObjectsForNSNullKeysFromArray:arrayItem]];
        }
    }
    
    //第三步：处理所有的NSDictionary元素
    for (int i=0; i<[ret count]; i++)
    {
        id arrayItem = ret[i];
        if ([arrayItem isKindOfClass:[NSDictionary class]]
            ||
            [arrayItem isKindOfClass:[NSMutableDictionary class]])
        {
            [ret replaceObjectAtIndex:i withObject:[self removeObjectsForNSNullKeysFromDictionary:arrayItem]];
        }
    }
    
    return [ret copy];
}


@end
