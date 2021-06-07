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
}

@end
