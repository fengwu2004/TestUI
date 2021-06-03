//
//  EBThreadSafeArray.mm
//  TZYJ_IPhone
//
//  Created by li on 2021/6/1.
//  Copyright © 2021 光大证券股份有限公司. All rights reserved.
//

#import "EBThreadSafeArray.h"
#include <mutex>

//--------------------------------------------------------
@interface EBThreadSafeArray() {
    
    std::mutex mux;
}

@property(nonatomic) NSMutableArray *array;

@end

@implementation EBThreadSafeArray

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _array = [NSMutableArray new];
    }
    
    return self;
}

- (void)forEach:(void(^)(id item))func {
    
    if (!func) {
        
        return;
    }
    
    NSInteger nIndex = 0;
    
    id item = [self itemAt:nIndex];
    
    while (item) {
        
        func(item);
        
        nIndex += 1;
        
        item = [self itemAt:nIndex];
    }
}

- (id)itemAt:(NSInteger)index {
    
    std::lock_guard<std::mutex> lk(mux);
    
    if (index < 0 || index >= _array.count) {
        
        return nil;
    }
    
    return _array[index];
}

- (void)pushBack:(id)item {
    
    if (!item) {
        
        return;
    }
    
    std::lock_guard<std::mutex> lk(mux);
    
    [_array addObject:item];
}

- (void)removeAllItems {
    
    std::lock_guard<std::mutex> lk(mux);
    
    [_array removeAllObjects];
}

- (void)removeItemAt:(NSInteger)index {
    
    std::lock_guard<std::mutex> lk(mux);
    
    if (index < 0 || index >= _array.count) {
        
        return;
    }
    
    [_array removeObjectAtIndex:index];
}

- (void)resetTo:(NSArray *)array {
    
    std::lock_guard<std::mutex> lk(mux);
    
    [_array removeAllObjects];
    
    if (array) {
        
        [_array addObjectsFromArray:array];
    }
}

- (void)removeItem:(id)item {
    
    if (!item) {
        
        return;
    }
    
    std::lock_guard<std::mutex> lk(mux);
    
    [_array removeObject:item];
}

- (NSArray<id> *)backItems {
    
    NSMutableArray *temps = [NSMutableArray new];
    
    {
        std::lock_guard<std::mutex> lk(mux);
        
        [temps addObjectsFromArray:_array];
    }
    
    return temps;
}

- (NSInteger)count {
    
    std::lock_guard<std::mutex> lk(mux);
    
    return _array.count;
}

@end
