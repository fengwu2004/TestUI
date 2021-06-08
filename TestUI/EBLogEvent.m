//
//  EBLogEvent.m
//  TestUI
//
//  Created by li on 2021/6/7.
//

#import "EBLogEvent.h"

#define EBMakeLogEvent(eventId, eventName) [EBLogEvent eventWith:(eventId) name:(eventName)]

@implementation EBLogEvent

+ (NSDictionary *)typeDict {
    
    static dispatch_once_t onceToken;
    
    static NSDictionary *dic = nil;
    
    dispatch_once(&onceToken, ^{
        
        dic = @{
            @(kApplicationDidFinishLaunchingEventId): EBMakeLogEvent(30000001, @"app启动"),
            @(kApplicationWillEnterForeground): EBMakeLogEvent(30000002, @"app进前台"),
            @(kApplicationDidEnterBackground): EBMakeLogEvent(30000003, @"app进后台"),
        };
    });
    
    return dic;
}

+ (NSString *)eventName:(EBLogEventType)type {
    
    return self.typeDict[@(type)];
}

+ (instancetype)eventWith:(NSInteger)eventId name:(NSString *)name {
    
    EBLogEvent *event = [EBLogEvent new];
    
    event.eventId = eventId;
    
    event.eventName = name;
    
    return event;
}

@end
