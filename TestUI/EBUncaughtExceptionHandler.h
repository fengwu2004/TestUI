//
//  UncaughtExceptionHandler.h
//  UncaughtExceptionHandler
//
//
//  Created by li on 2021/6/1.
//  Copyright © 2021 光大证券股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EBUncaughtExceptionHandler : NSObject

+ (void)run;

+ (void)uploadCrashLogFile;


@end
