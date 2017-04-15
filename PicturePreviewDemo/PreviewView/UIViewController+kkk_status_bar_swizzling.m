//
//  UIViewController+kkk_status_bar_swizzling.m
//  picsSelect
//
//  Created by KKK on 16/4/20.
//  Copyright © 2016年 dwd. All rights reserved.
//

#import "UIViewController+kkk_status_bar_swizzling.h"
#import "KKImageViewScrollView.h"

#import <objc/runtime.h>

@implementation UIViewController (kkk_status_bar_swizzling)

- (BOOL)kk_hideStatusBar {
    return YES;
}

@end
