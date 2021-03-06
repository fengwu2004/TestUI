//
//  EBStoreManager.h
//  TZYJ_IPhone
//
//  Created by li on 2021/6/1.
//  Copyright © 2021 光大证券股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------
typedef NS_ENUM(NSInteger, EBPathKey) {
    
    EBPathKey_SystemLogFile,
    EBPathKey_SystemCrashFile,
};

typedef NS_ENUM(NSInteger, EBStoreCiperType) {
    
    EBStoreCiperType_RC4 = 1, //default
};

//----------------------------------------------------------------------------------------------------------
@interface EBPathSetting : NSObject

@property(nonatomic, copy) NSString *path;
@property(nonatomic, copy) NSString *fileName;
@property(nonatomic) EBStoreCiperType ciperType;

+ (id)pathFrom:(NSString *)path fileName:(nullable NSString *)fileName;

@end

//----------------------------------------------------------------------------------------------------------

@interface EBStoreManager : NSObject

+ (id)sharedInstance;

- (void)saveToPath:(EBPathKey)path fileName:(NSString *)fileName array:(NSArray *)array;

- (void)saveToPath:(EBPathKey)path fileName:(NSString *)fileName data:(NSData *)data;

- (void)appendToPath:(EBPathKey)path fileName:(NSString *)fileName data:(NSData *)data;

- (void)removeFile:(EBPathKey)path fileName:(NSString *)fileName;

- (NSData *)fileData:(EBPathKey)path fileName:(NSString *)fileName;

- (NSArray<NSString *> *)fileListOfPath:(EBPathKey)path;

- (NSString *)fileExtensionOf:(EBPathKey)pathKey;


@end

NS_ASSUME_NONNULL_END
