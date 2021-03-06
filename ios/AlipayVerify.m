//
//  AlipayVerify.m
//
//  Created by Deng Xiang Hong on 2021/12/07.
//
#import "AlipayVerify.h"
#import <AlipayVerifySDK/APVerifyService.h>

@implementation AlipayVerify

RCT_EXPORT_MODULE()

// 获取 bizCode
// 每开启一次认证都需客户端重新获取一次 bizCode 并将其传入服务端，作为  alipay.user.certify.open.initialize (身份认证初始化服务) 接口中 biz_code 参数值。
RCT_REMAP_METHOD(getBizCode,
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *bizcode = [[APVerifyService sharedService] bizCode];
    resolve(bizcode);
}

// 开始刷脸服务
// TODO 未安装支付宝时无法打开内置SDK进行认证
// 客户端与服务端中 bizCode 参数值需保持一致。
RCT_REMAP_METHOD(verify,
                 verifyWithA:(nonnull NSString*)certifyId withB:(nonnull NSString*)certifyUrl
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *bizcode = [[APVerifyService sharedService] bizCode];
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [[APVerifyService sharedService] startVerifyService:@{@"url": certifyUrl?:@"test-certifyUrl",
                                                          @"certifyId": certifyId?:@"test-certifyId",
                                                          @"ext": @"test-extInfo",
                                                          @"bizcode": bizcode}
                                                 target:rootViewController
                                                  block:^(NSMutableDictionary * resultDic){
        resolve([resultDic valueForKey:@"resultStatus"]);
    }];
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"EventReminder"];
}

@end
