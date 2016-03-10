//
//  UnionApplePayUtil.m
//  UPPayTest
//
//  Created by 奉强 on 16/3/8.
//  Copyright © 2016年 奉强. All rights reserved.
//

#import "UnionApplePayUtil.h"
#import "UPAPayPlugin.h"
#import "UPAPayPluginDelegate.h"
#import "MBProgressHUD/MBProgressHUD.h"

//支付参数
#define TNURLString @"http://101.231.204.84:8091/sim/getacptn"
#define APMechantID @"merchant.com.pmit.FengQiang.UPPayTest"
//测试环境
#define PayTest 1

static UnionApplePayUtil *applePayUtil;

@interface UnionApplePayUtil () <UPAPayPluginDelegate>

// 支付的那个ViewController
@property (nonatomic, strong) UIViewController *fromViewController;

// 支付号
@property (nonatomic, strong) NSString *tnNumberString;




@end



@implementation UnionApplePayUtil

#pragma mark 支付接口
- (void)startPayFromviewController:(UIViewController*)viewController payResaultBlock:(UnionApplePayUtilPayRsaultBlock)payRsaultBlock {
    self.fromViewController = viewController;
    self.PayRsaultBlock = payRsaultBlock;
    //首先向后台请求TN支付单号
    [self getTN];
}

#pragma mark 创建支付单例
+ (instancetype)shareUnionApplePayUtil {
    if (!applePayUtil) {
        applePayUtil = [[UnionApplePayUtil alloc] init];
    }
    
    return applePayUtil;
}

#pragma mark 支付结果回调
- (void)UPAPayPluginResult:(UPPayResult *)payResult {
    
    NSString *resultString;
    
    switch (payResult.paymentResultStatus) {
        case UPPaymentResultStatusSuccess:
            resultString = @"支付成功";
            break;
            
        case UPPaymentResultStatusFailure:
            resultString = @"支付失败";
            break;
            
        case UPPaymentResultStatusCancel:
            resultString = @"支付被取消";
            break;
            
        case UPPaymentResultStatusUnknownCancel:
            resultString = @"支付取消，交易已发起，状态不确定，商户需查询商户后台确认支付状态";
            break;
            
        default:
            resultString = @"未知状态";
            break;
    }
    
    NSLog(@"支付结果==%@", resultString);
    NSLog(@"错误信息==%@", payResult.errorDescription);
    NSLog(@"优惠信息==%@", payResult.otherInfo);
    static UILabel *resaultText;
    if (!resaultText) {
        resaultText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
        [self.fromViewController.view addSubview:resaultText];
    }
    resaultText.text = [NSString stringWithFormat:@"支付结果==%@   错误信息==%@\n   优惠信息==%@", resultString, payResult.errorDescription, payResult.otherInfo];
    resaultText.numberOfLines = 0;
    
    
    if (self.PayRsaultBlock) {
        self.PayRsaultBlock(payResult);
    }
}

#pragma mark - 网络请求相关
#pragma mark 请求tn
- (void)getTN {
    //菊花提示一下
    [MBProgressHUD showHUDAddedTo:self.fromViewController.view animated:YES];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURL *tnUrl = [NSURL URLWithString:TNURLString];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:tnUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        self.tnNumberString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"支付单号：%@", self.tnNumberString);
        dispatch_sync(dispatch_get_main_queue(), ^{
            //隐藏菊花
            [MBProgressHUD hideHUDForView:self.fromViewController.view animated:YES];
            
            
        });
        
        //开始支付
        NSString *payMode = @"00";//默认生产环境
#ifdef PayTest
        payMode = @"01";//改成测试环境
#endif
        //测试环境
        [UPAPayPlugin startPay:self.tnNumberString mode:payMode viewController:self.fromViewController delegate:self andAPMechantID:APMechantID];
    }];
    
    [dataTask resume];
}



@end
