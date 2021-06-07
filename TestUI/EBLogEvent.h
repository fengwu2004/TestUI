//
//  EBLogEvent.h
//  TestUI
//
//  Created by li on 2021/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EBLogEventType) {
    
    kApplicationDidFinishLaunchingEventId,          //app启动
    
    kApplicationWillEnterForeground,                //app进前台
    
    kApplicationDidEnterBackground, //app进后台
    
    kConnectQuotationEventId,   //连接行情通道
    
    kNegotiateQuotationEventId, //协商行情通道
    
    kConnectBusinessEventId,    //连接业务通道
    
    kNegotiateBusinessEventId,  //协商业务通道
    
    kConnectTradeEventId,       //连接交易通道
    
    kNegotiateTradeEventId,     //协商交易通道
    
    kGetAddressListEventId,     //获取地址列表
    
    kSendPacketFailedWithClientErrorEventId,    //因客户端原因导致发包失败
    
    kNetworkStateSwitchEventId,                 //网络状态切换
    
    kPingTimeoutEventId,                        //ping超时
    
    kKeepAliveFailedEventId, //保活失败
    
    kGetVerificationCodeFailedEventId, //手机验证码接口请求失败
    
    kSocketEventId,//底层socket信息
    /// 3000024 统一下载服务信息
    kUniversalDownloadServiceEventId,
    /// 3000025 增强行情通道断开
    kEnhancedQuotationDisconnectEventId,
    /// 3000026 H5页面加载失败
    kH5FileDidFailLoadEventId,
    /// 3000027 获取token失败
    kGetTokenFailedEventId,
    /// 3000028 是否打开APNs
    kOpenAPNsEventId,
    /// 3000029 App运行时长
    kRunningTimeLenEventId,
    /// 3000030 使用流量
    kNetworkDataTrafficEventId,
    /// 3000031 ping
    kPingEventId,
    /// 3000032 隐私信息收集
    kAppPrivacyPolicyEventId,
    /// 3000035 网络请求失败
    kRequestFailedEventId,
    /// 3000039 iOS内存警告
    kMemoryWarningEventId,
    /**
     *  推送
     */
    /// 3000200 APNS消息点击
    kClickAPNSMessageEventId,
    /// 3000201 Socket消息点击
    kClickSocketMessageEventId,
    /**
     *  交易登录
     */
    /// 3000800 登录
    kLoginInfoEventId,
    /// 3000801 在线时长修改
    kOnlineIntervelSettingEventId,
    /// 3000802 立即开户
    kOpenAccountImmediatelyEventId,
    /// 3000803 客服热线
    kCustomerServiceHotlineEventId,
    /// 3000804 删除历史账号
    kDeleteAccountEventId,
    /// 3000805 passportId获取失败的原因
    kPassportIDGetFailedEventId,
    /*
     *  交易委托买卖
     */
    /// 3000900 委托
    kTradeInfoEventId,
    /// 3000901 合约按钮点击
    kContractButtonClickEventId,
    /// 3000902 标的券查询按钮点击
    kUnderlyingSecuritiesButtonClickEventId,
    /// 3000903 持仓股的股东账号匹配失败
    kStockAccountFromStorageMatchFailedEventId,
    // 3000904 点击预估涨跌停问号
    kEstimatedLimitPriceTipButtonClickEventId,
    /**
     *  其他
     */
    /// 3001000 服务器地址设置
    kServerAddressSettingEventId,
    /// 3001003 搜索结果标的点击
    kSearchPageJumpCompositeEventId,
    /// 3001004 在搜索页添加/删除自选
    kSearchPageEditOptionalsEventId,
    /// 3001005 详情宫格更多页tab切换
    kCompositeGridMorePageTabSwitchEventId,
    /// 3001006 默认首页设置
    kDefaultHomePageSettingEventId,
    /// 3001007 退出用户按钮点击
    kLogoutUserButtonClickEventId,
    /// 3001008 切换用户按钮点击
    kSwitchUserButtonClickEventId,
    /**
     *  交易首页
     */
    /// 3001100 资产信息的隐私按钮
    kNormalTradeHomePageAssetEyeButtonEventId,
    /// 3001101 账号选择框，切换账号点击
    kNormalTradeHomePageSwitchAccountEventId,
    /// 3001102 账号选择框，退出当前账号点击
    kNormalTradeHomePageLogOutAccountEventId,
    /// 3001103 交易首页底部，退出登录点击
    kNormalTradeHomePageBottomLogOutEventId,
    /// 3001104 其它按钮的点击事件
    kNormalTradeHomePageOtherButtonEventId,
    /**
     *  信用交易首页
     */
    /// 3001200 资产信息的隐私按钮
    kCreditTradeHomePageAssetEyeButtonEventId,
    /// 3001201 账号选择框，切换账号点击
    kCreditTradeHomePageSwitchAccountEventId,
    /// 3001202 账号选择框，退出当前账号点击
    kCreditTradeHomePageLogOutAccountEventId,
    /// 3001203 交易首页底部，退出登录点击
    kCreditTradeHomePageBottomLogOutEventId,
    /// 3001204 其它按钮的点击事件
    kCreditTradeHomePageOtherButtonEventId,
    /**
     *  普通持仓
     */
    /// 3001300 买入、卖出、行情、配股等按钮点击
    kNormalPositionPageListButtonEventId,
    /// 3001301 取款按钮点击
    kNormalPositionPageAtmButtonEventId,
    /**
     *  信用持仓
     */
    /// 3001400 买入、卖出、行情等按钮点击
    kCreditPositionPageListButtonEventId,
    /**
     *  信用资产负债
     */
    /// 3001500 卖券还款等按钮点击
    kCreditAssetsLiabilitiesPageListButtonEventId,
    /**
     *  资金流向页面
     */
    /// 3001600 我的自选/沪深市场切换
    kOptionalHSMaketSwitchEventId,
    /// 3001601 资金流向页面排序
    kCapitalInfoPageSortEventId,
    /**
     *  用户体系
     */
    /// 3001700 注册流程
    kRegistrationProcessEventId,
    /// 3001701 设置页进入的信息导入流程
    kInfoImportProcessFromSeetingPageEventId,
    /// 3001702 信息导入接口
    kInfoImportNetworkRequestEventId,
    /**
     *  科创板交易首页
     */
    /// 3001801 账号选择框，切换账号点击
    kNormalTradeHomeTIBPageSwitchAccountEventId,
    /// 3001802 账号选择框，退出当前账号点击
    kNormalTradeHomeTIBPageLogOutAccountEventId,
    /// 3001803 其它按钮的点击事件
    kNormalTradeHomeTIBPageOtherButtonEventId,
    /**
     *  科创板信用交易首页
     */
    /// 3001901 账号选择框，切换账号点击
    kCreditTradeHomeTIBPageSwitchAccountEventId,
    /// 3001902 账号选择框，退出当前账号点击
    kCreditTradeHomeTIBPageLogOutAccountEventId,
    /// 3001903 其它按钮的点击事件
    kCreditTradeHomeTIBPageOtherButtonEventId,
    /**
     *  科创板普通持仓
     */
    /// 3002001 买入、卖出、行情、配股等按钮点击
    kNormalTIBPositionPageListButtonEventId,
    /**
     *  科创板信用持仓
     */
    /// 3002101 买入、卖出、行情等按钮点击
    kCreditTIBPositionPageListButtonEventId,
    
    /**
     *  今日交易
     */
    /// 3002201 今日交易Tab切换
    kNormalDailyTradeSegmentSwitchEventId,
    /// 3002202 今日交易撤单
    kNormalDailyTradeRevokeEventId,
    /**
     *  银证转账
     */
    /// 3002301 银证转账tab切换
    kBankSecurityTransferSegmentTapEventId,
    /// 3002302 数据请求异常
    kBankSecurityTransferNetErrorEventId,
    /// 3002303 立即转账
    kBankSecurityTransferInstantTransferEventId,
    /// 3002304 按键点击
    kBankSecurityTransferBtnClickEventId,
    /// 3002305 余额查询
    kBankSecurityTransferQueryBalanceEventId,
    /// 3002306 内部资金调拨
    kBankSecurityTransferInternalAllocationComfirmEventId,
    /**
     *  指纹登录
     */
    /// 3002401 开通指纹登录
    kVerificationOpenEventId,
    /// 3002402 关闭指纹登录
    kVerificationCloseEventId,
    /// 3002403 快捷变更及激活
    kVerificationQuickLoginChangeOrActiveEventId,
    /// 3002404 多账号开关
    kVerificationMultipleAccountsStatusEventId,
    /// 3002405 指纹登录失败
    kVerificationLoginFailEventId,
    /// 3002406 快捷切换失败
    kVerificationQucikLoginSwitchFailEventId,
    /// 3002407 登录方式
    kVerificationQucikLoginTypeEventId,
    /**
     *  新股
     */
    /// 3002501 新股申购柜台列表请求结果(获取柜台今日列表)
    kGetStockTodayListEventId,
    /// 3002502 新股申购中间件列表请求结果(获取中间件今日列表)
    kGetStockMiddlewareTodayListEventId,
    /// 3002504 新股申购配额请求失败或不匹配(获取配额)
    kGetStockQuotaEventId,
    /// 3002505 新股确认申购及结果(确认申购单个标的)
    kSubscriptionStockEventId,
    /**
     *  新债
     */
    /// 3002601 新债申购柜台列表请求结果(获取柜台今日列表)
    kGetBondTodayListEventId,
    /// 3002602 新债申购中间件列表请求结果(获取中间件今日列表)
    kGetBondMiddlewareTodayListEventId,
    /// 3002604 新债确认申购及结果(确认申购单个标的)
    kSubscriptionBondEventId,
    /// 3002605 新债配售确认及结果
    kPlacingBondEventId,
    /**
     *  动态配置相关
     */
    /// 3002701 持久token获取失败
    kDurableTokenFailedEventId,
    /// 3002702 一次性token获取失败
    kInstantTokenFailedEventId,
    /// 3002703 个股/行情/科创版调整后的顺序
    kDynamicCongfigChangeMenuOrderEventId,
    /// 3002704 个股/行情/科创版Item点击
    kComposteAndMarketConfigabelScrollbarEventId,
    /**
     *  个股异动
     */
    /// 3002800 个股异动设置修改事件(个股异动是否显示以及显示指标)
    kAbnormalVolatilitySettingChangeEventId,
    /**
     *  持仓股行情
     */
    /// 3002900 持仓股请求失败
    kPositionSecuritiesRequestFailed,
    /// 3002901 持仓股同步账号开关状态
    kPositionAccountSyncStateEventId,
    /// 3002902 持仓股tab切换
    kPositionTabSwitchEventId,
    /// 3002903 持仓股编辑按钮
    kPositionEditEventId,
    /// 3002904 持仓股列表排序
    kPositionSortEventId,
    /// 3002905 持仓股首页点的新闻/公告
    kPositionTapNewsButtonEventId,
    /// 3002906 持仓股定制按钮点击
    kPositionTapEditIndexButtonEventId,
    /// 3002907 持仓资讯tab切换
    kPositionNewsPageTabSwitchEventId,
    /// 3002908 持仓自选切换
    kStocksGroupTypeSwitchEventId,
    /**
     *  综合搜索
     */
    /// 3003001 综合搜索大tab切换
    kComprehensiveSearchSwitchFirstCategoryEventId,
    /// 3003002 推荐功能点击
    kComprehensiveSearchRecommendedFeaturesEventId,
    /// 3003003 浏览历史标的点击
    kComprehensiveSearchRecentlyBrowsedTapSecuritiesEventId,
    /// 3003004 浏览历史清除
    kComprehensiveSearchRecentlyBrowsedClearAllEventId,
    /// 3003005 热门股票标的点击
    kComprehensiveSearchTapHotStockEventId,
    /// 3003006 热门股票换一批
    kComprehensiveSearchChangeBatchEventId,
    /// 3003007 用户登录
    kComprehensiveSearchUserLoginEventId,
    /// 3003008 一键导入
    kComprehensiveSearchOneClickImportEventId,
    /// 3003009 热门产品点击
    kComprehensiveSearchTapHotProductEventId,
    /// 3003010 综合搜索小tab切换
    kComprehensiveSearchSwitchSecondaryCategoryEventId,
    /// 3003011 综合搜索结果item点击
    kComprehensiveSearchTapResultItemEventId,
    /// 3003012 理财组合全部tab查看更多点击
    kComprehensiveSearchFinancingAndGroupTapMoreEventId,
    /**
     *  策略单
     */
    /// 3003101 策略单首页点击策略入口
    kConditionalOrderHomeStrategyEntranceId,
    /// 3003102 策略单编辑页切换策略类型
    kConditionalOrderEditStrategyTitleBarSwitchId,
    /// 3003103 策略单确认提交
    kConditionalOrderConfirmSubmitId,
    /// 3003104 策略单详情页按钮点击
    kConditionalOrderDetailButtonId,
    /// 3003105 策略单列表页提交委托
    kConditionalOrderListCommitEntrustId,
    
    /**
     * 创业板普通交易首页
     */
    /// 3003201 账号选择框，切换账号点击
    kNormalTradeHomeGEMPageSwitchAccountEventId,
    /// 3003202 账号选择框，退出当前账号点击
    kNormalTradeHomeGEMPageLogOutAccountEventId,
    /// 3003203 其它按钮的点击事件
    kNormalTradeHomeGEMPageOtherButtonEventId,
    /**
     * 创业板信用交易首页
     */
    /// 3003301 账号选择框，切换账号点击
    kCreditTradeHomeGEMPageSwitchAccountEventId,
    /// 3003302 账号选择框，退出当前账号点击
    kCreditTradeHomeGEMPageLogOutAccountEventId,
    /// 3003303 其它按钮的点击事件
    kCreditTradeHomeGEMPageOtherButtonEventId,
    /**
     * 创业板普通持仓
     */
    /// 3003401买入、卖出、行情、配股等按钮点击
    kNormalGEMPositionPageListButtonEventId,
    /**
     * 创业板信用持仓
     */
    /// 3003501 买入、卖出、行情等按钮点击
    kCreditGEMPositionPageListButtonEventId,
    /**
     * 新三板普通持仓
     */
    /// 3003601 买入、卖出、行情、配股等按钮点击
    kNormalNEEQPositionPageListButtonEventId,
    /// 3003901 新三板账号选择框，切换账号点击
    kNormalTradeHomeNEEQPageSwitchAccountEventId,
    /// 3003902 新三板账号选择框，退出当前账号点击
    kNormalTradeHomeNEEQPageLogOutAccountEventId,
    /// 3003903 新三板其他按钮点击事件
    kNormalTradeHomeNEEQPageOtherButtonEventId,
    
    /// 3004001 新三板要约委托结果
    KNormalNEEQOfferEntrustResultEventId,
    /// 3004002 新三板要约列表项点击
    KNormalNEEQOfferListClickEventId,
    /// 3004003 新三板要约记录按钮点击
    KNormalNEEQOfferRecordButtonClickEventId,
    
    /**
     * 股转询价
     */
    /// 3003701 股转询价确认及结果
    kNEEQOfferingResultEventId,
    /// 3003702 询价申报查询
    kNEEQOfferingQueryListEventId,
    /// 3003703 询价结果查询
    kNEEQOfferingResultListEventId,
    
    /**
     * 股转申购
     */
    /// 3003801 股转申购确认及结果
    kNEEQSubscriptionResultEventId,
    /// 3003802 申购查询
    kNEEQSubscriptionQueryListEventId,
    /// 3003803 中签查询
    kNEEQSubscriptionResultListEventId,
    
    /**
     * 多点登录
     */
    // 3004101 多点登录弹框，查看登录历史点击
    kLoginJumpToHistroyViewEventId,
    // 3004102 多点登录弹框，忽略本次点击
    kLoginAlertDismissEventId,
    // 3004103 多点登录弹框，不再提醒点击
    kLoginAlertIgnoreEventId,
    // 3004104 登录历史查询页面显示
    kLoginHistoryViewDisplayEventId,
    // 3004105 多点登录提醒管理开关
    kLoginRemindManageEventId,
    
    /// 3004201 快速交易全屏按钮点击
    KQuickTradeFullScreenEventId,
    /// 3004202 快速交易账号切换按钮点击
    kQuickTradeSwitchAccountEventId,
    /// 3004203 快速交易确认页返回按钮
    KQuickTradeBackFromConfirmPageEventId,
    /// 3004204 快速交易确认页关闭按钮点击
    KQuickTradeCloseConfirmPageEventId,
    /// 3004205 快速交易结果页返回按钮点击
    KQuickTradeBackFromResultPageEventId,
    /// 3004206 快速交易结果页再次委托点击
    KQuickTradeEntrustAgainEventId,
    /// 3004207 快速交易结果页刷新按钮点击
    KQuickTradeResultRefreshEventId,
    /// 3004208 快速交易继续委托按钮点击
    KQuickTradeEntrustContinueEventId
};

@interface EBLogEvent : NSObject

@property(nonatomic) NSInteger eventId;
@property(nonatomic) NSString *eventName;

+ (instancetype)eventWith:(NSInteger)eventId name:(NSString *)name;

+ (NSString *)eventName:(EBLogEventType)type;

@end

NS_ASSUME_NONNULL_END
