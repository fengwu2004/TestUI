//
//  EBLogManager.h
//  TZYJ_IPhone
//
//  Created by li on 2021/6/1.
//  Copyright © 2021 光大证券股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EBLogAnalyticManager : NSObject

+ (instancetype)sharedInstance;

- (void)run;

- (void)saveLog:(NSDictionary *)dic;

- (void)forceStoreLogs;

- (void)forceUpdateLogs;

@end

NS_ASSUME_NONNULL_END
