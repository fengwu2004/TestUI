//
//  EBLogEvent.h
//  TestUI
//
//  Created by li on 2021/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EBLogEventType) {
    
    //系统信息
    kApplicationDidFinishLaunchingEventId,          //app启动
    kApplicationWillEnterForeground,                //app进前台
    kApplicationDidEnterBackground,                 //app进后台
    kConnectQuotationEventId,                       //连接行情通道
    kNegotiateQuotationEventId,                     //协商行情通道
    kConnectBusinessEventId,                        //连接业务通道
    kNegotiateBusinessEventId,                      //协商业务通道
    kConnectTradeEventId,                           //连接交易通道
    kNegotiateTradeEventId,                         //协商交易通道
    kGetAddressListEventId,                         //获取地址列表
    kSendPacketFailedWithClientErrorEventId,        //因客户端原因导致发包失败
    kNetworkStateSwitchEventId,                     //网络状态切换
    kPingTimeoutEventId,                            //ping超时
    kKeepAliveFailedEventId,                        //保活失败
    kGetVerificationCodeFailedEventId,              //手机验证码接口请求失败
    kSocketEventId,                                 //底层socket信息
    
    //http请求
    kGetTokenFailedEventId,                         //获取token失败
    kOpenAPNsEventId,                               //是否打开APNs
    kClickAPNSMessageEventId,                       //APNS消息点击
    kRunningTimeLenEventId,                         //App运行时长
    kNetworkDataTrafficEventId,                     //使用流量
    kPingEventId,                                   //ping
    kAppPrivacyPolicyEventId,                       //隐私信息收集
    kRequestFailedEventId,                          //网络请求失败
    kMemoryWarningEventId,                          //iOS内存警告
};

@interface EBLogEvent : NSObject

@property(nonatomic) NSInteger eventId;
@property(nonatomic) NSString *eventName;

+ (instancetype)eventWith:(NSInteger)eventId name:(NSString *)name;

+ (NSString *)eventName:(EBLogEventType)type;

@end

NS_ASSUME_NONNULL_END
