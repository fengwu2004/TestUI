//
//  EBThreadSafeArray.h
//  TZYJ_IPhone
//
//  Created by li on 2021/6/1.
//  Copyright © 2021 光大证券股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EBThreadSafeArray<ObjectType> : NSObject

- (id)itemAt:(NSInteger)index;

- (void)removeItemAt:(NSInteger)index;

- (void)removeItem:(id)item;

- (void)pushBack:(id)item;

- (void)removeAllItems;

- (void)forEach:(void(^)(id item))func;

- (void)resetTo:(NSArray *)array;

- (NSInteger)count;

@end

NS_ASSUME_NONNULL_END
