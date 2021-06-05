//
//  TestManager.m
//  TestUI
//
//  Created by li on 2021/6/5.
//

#import "TestManager.h"

@implementation TestManager

+ (void)test {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *array = @[];
        
        NSLog(@"%@", array[1]);
    });
}

@end
