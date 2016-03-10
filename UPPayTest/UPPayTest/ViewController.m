//
//  ViewController.m
//  UPPayTest
//
//  Created by 奉强 on 16/3/8.
//  Copyright © 2016年 奉强. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>
#import "UnionApplePayUtil.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建苹果支付按钮
    [self creatPayButton];
}

#pragma mark 创建苹果支付按钮
- (void)creatPayButton {
    PKPaymentButton *payButton = [[PKPaymentButton alloc] initWithPaymentButtonType:PKPaymentButtonTypeBuy paymentButtonStyle:PKPaymentButtonStyleWhite];
    
    payButton.center = self.view.center;
    payButton.bounds = CGRectMake(0, 0, 200, 50);
    
    [payButton addTarget:self action:@selector(payButtonClickHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
}

#pragma mark 点击支付按钮之后
- (void)payButtonClickHandle {
    [[UnionApplePayUtil shareUnionApplePayUtil] startPayFromviewController:self payResaultBlock:nil];
}


@end
