//
//  TestManager.m
//  TestUI
//
//  Created by li on 2021/6/5.
//

#import "TestManager.h"
#import "EBCyptor.h"

@implementation TestManager

+ (void)test {

    NSString *a = @"abcdefgh";
    
    NSData *data = [a dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", data);
    
    NSData *ciperData = [EBCyptor ciperWithRC4:data];
    
    NSLog(@"%@", ciperData);
    
    NSData *deciperData = [EBCyptor deciperWithRC4:ciperData];
    
    NSLog(@"%@", deciperData);
    
    NSLog(@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray *array = @[];
            
            NSLog(@"%@", array[1]);
        });
    });
}

@end
