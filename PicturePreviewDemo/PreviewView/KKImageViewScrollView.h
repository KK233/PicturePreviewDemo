//
//  KKImageViewScrollView.h
//  picsSelect
//
//  Created by KKK on 16/4/15.
//  Copyright © 2016年 KK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKPhotoMetaModel.h"

@class KKImageViewScrollView;
@class KKImagesScrollView;
@protocol KKImageViewScrollViewDelegate <NSObject>
@optional
/**
 *  用于dismiss整个大图预览view的代理
 */
- (void)imageViewScrollViewDidTapToDismiss:(KKImageViewScrollView *)imageViewScrollView;
@end

@interface KKImageViewScrollView : UIScrollView

@property (nonatomic, strong) KKPhotoMetaModel *photoMeta;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, weak) KKImagesScrollView *containerScrollView;

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, weak) id<KKImageViewScrollViewDelegate> dismissDelegate;

- (instancetype)initWithPhotoMeta:(KKPhotoMetaModel *)photoMeta photoRect:(CGRect)rect;
- (void)setNeedsLoadingOriginImage;

@end
