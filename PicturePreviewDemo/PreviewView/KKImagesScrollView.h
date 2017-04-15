//
//  KKImagesScrollView.h
//  picsSelect
//
//  Created by KKK on 16/4/15.
//  Copyright © 2016年 KK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKPhotoMetaModel;
@interface KKImagesScrollView : UIScrollView

/**
 *  初始化方法
 *
 *  @param photoMetaArray 内容是<KKPhotoMetaModel>的数组
 *
 */
- (instancetype)initWithPhotoMetaArray:(NSArray<KKPhotoMetaModel *> *)photoMetaArray;

/**
 *  展示页面
 *
 *  @param imgView       当前点击的图片
 *
 *  @param index         当前点击的图片是图片数组中的第X个(从0开始)
 *
 *  @param containerView 点击图片的容器View, 本来是用于处理dismiss时的动画效果,但是现在并不是所有的图片制式是一样的
 *                       所以会导致不准确,现在可随意填写,当有了规范后再在dismiss处进行修改
 */
- (void)presentViewFromImageView:(UIImageView *)imgView atIndex:(NSInteger)index toContainer:(UIView *)containerView;
@end







/**
 *  scrollView的分类,用于Method Swizzling,进行顶部status bar的隐藏和显示
 *  由于直接修改status bar的方法在iOS8(9?)中已经弃用,所以使用Method Swizzling对status bar进行操作,仅用于大图预览
 */
@interface KKImagesScrollView (swizzling)
- (void)exchangeStatusBar;

@end
