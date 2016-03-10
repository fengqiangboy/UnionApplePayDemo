//
//  UnionApplePayUtil.h
//  UPPayTest
//
//  Created by 奉强 on 16/3/8.
//  Copyright © 2016年 奉强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UPPayResult;

typedef void(^UnionApplePayUtilPayRsaultBlock)(UPPayResult *payResult);

@interface UnionApplePayUtil : NSObject

//支付结果回调block
@property (nonatomic, copy) UnionApplePayUtilPayRsaultBlock PayRsaultBlock;

/**
 *  支付接口
 *
 *  @param viewController 启动支付控件的viewController
 *
 *  @return 调用是否成功
 */
- (void)startPayFromviewController:(UIViewController*)viewController payResaultBlock:(UnionApplePayUtilPayRsaultBlock)payRsaultBlock;


/**
 *  获取支付单例对象
 *
 *  @return 支付单例对象
 */
+ (instancetype)shareUnionApplePayUtil;

@end
