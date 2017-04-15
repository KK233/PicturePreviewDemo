//
//  KKLargeImageViewScrollView.m
//  picsSelect
//
//  Created by KKK on 16/4/15.
//  Copyright © 2016年 KK. All rights reserved.
//

#import "KKImageViewScrollView.h"
#import "KKImagesScrollView.h"

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface KKImageViewScrollView ()<UIScrollViewDelegate, UIActionSheetDelegate>
//进度条

@property (nonatomic, weak) CAShapeLayer *progressLayer;

@property (nonatomic, strong) NSTimer *singleTapTimer;

@end

@implementation KKImageViewScrollView

- (instancetype)initWithPhotoMeta:(KKPhotoMetaModel *)photoMeta photoRect:(CGRect)rect {
    _photoMeta = photoMeta;
    self = super.init;
    if (!self) return nil;
    self.delegate = self;
    self.bouncesZoom = YES;
    self.maximumZoomScale = 3;
    self.minimumZoomScale = 1;
    self.multipleTouchEnabled = YES;
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = NO;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    
    //从缓存取图片
    imgView.image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[photoMeta thumbPhotoKey]];
    if (!imgView.image) {
        imgView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[photoMeta thumbPhotoKey]];
    }
    
    imgView.userInteractionEnabled = YES;
    [self addSubview:imgView];
    _imgView = imgView;
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    _progressLayer = layer;
    _progressLayer.frame = CGRectMake(0, 0, 40, 40);
    _progressLayer.cornerRadius = 20;
    _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
    _progressLayer.path = path.CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineWidth = 4;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [self.layer addSublayer:_progressLayer];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    CGRect frame = self.frame;
//    frame.origin.x = center.x - frame.size.width * 0.5;
//    frame.origin.y = center.y - frame.size.height * 0.5;
//    self.frame = frame;
    
    CGRect frame = _progressLayer.frame;
    frame.origin = CGPointMake((self.frame.size.width - _progressLayer.bounds.size.width) / 2.0, (self.frame.size.height - _progressLayer.bounds.size.width) / 2.0);
    frame.size = CGSizeMake(40, 40);
    _progressLayer.frame = frame;
}

- (void)setNeedsLoadingOriginImage {
    /*
     展示progressLayer
     读取原图
     完成后隐藏progressLayer
     **/
    
    _progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [CATransaction commit];
    
    __weak typeof(self) weakSelf = self;
    UIImage *image;
    
    //获取photoKey
    image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[_photoMeta thumbPhotoKey]];
    if (!image) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[_photoMeta thumbPhotoKey]];}
    if(!image) {
        image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[_photoMeta chatThumbPhotoKey]];}
    if (!image) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[_photoMeta chatThumbPhotoKey]];}
    
    /**
     
     临时处理
     
     */
    if (!image) {
        image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[_photoMeta thumbPhotoKey]];}
    if (!image) {
            image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[_photoMeta thumbPhotoKey]];}
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[_photoMeta originKey]] placeholderImage:image options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (!weakSelf) return;
        CGFloat progress = receivedSize / (float)expectedSize;
        progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
        weakSelf.progressLayer.hidden = NO;
        weakSelf.progressLayer.strokeEnd = progress;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.progressLayer.hidden = YES;
        
        UILongPressGestureRecognizer *longPressGR =
        [[UILongPressGestureRecognizer alloc] initWithTarget:weakSelf
                                                      action:@selector(handleLongPress:)];
        
        [longPressGR setMinimumPressDuration:0.4];
        [weakSelf addGestureRecognizer:longPressGR];
    }];
    
}

#pragma mark - Event Response
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1 && (touch.phase == UITouchPhaseStationary || touch.phase == UITouchPhaseEnded)) {
        _singleTapTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(scrollViewShouldDismiss) userInfo:nil repeats:NO];
    } else {
        [_singleTapTimer invalidate];
    }
    
    if (touch.tapCount == 2) {
        CGPoint tapPoint = [touch locationInView:self];
        
        CGFloat zoomScale = 0.0f;
        
        if (self.zoomScale != 1.0f) {
            zoomScale = 1.0f;
        } else {
            zoomScale = 2.0f;
        }
        
        [UIView animateWithDuration:0.25f animations:^{
            self.zoomScale = zoomScale;
        } completion:^(BOOL finished) {
        }];
        return;
    }
}

- (void)scrollViewShouldDismiss {
    if (self.dismissDelegate && [self.dismissDelegate respondsToSelector:@selector(imageViewScrollViewDidTapToDismiss:)]) {
        [self.dismissDelegate imageViewScrollViewDidTapToDismiss:self];
    }
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        UIAlertController *alctr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alctr addAction:cancel];
        UIAlertAction *saveToAlbum = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.imgView.image) {
                // 相册保存操作
//                [[KKPrivacyManager shareManger] needPrivacy:KKPrivacyTypePhotoLibrary withController:self.viewController authorized:^{
//                    UIImageWriteToSavedPhotosAlbum(self.imgView.image,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
//                }];
            }
        }];
        [alctr addAction:saveToAlbum];
        NSString *msg =  @"NO";// 识别二维码的操作 使用 CIFeature 或者 第三方库都可以 [NSString messageWithImage:self.imgView.image];
        if (msg != nil) {
            UIAlertAction *qrDetect = [UIAlertAction actionWithTitle:@"识别二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [KKQRClient requestAnalysisWithQRInfo:msg controller:_viewController];
                /**
                 识别二维码
                 **/
                
                if (_dismissDelegate && [_dismissDelegate respondsToSelector:@selector(imageViewScrollViewDidTapToDismiss:)]) {
                    [_dismissDelegate imageViewScrollViewDidTapToDismiss:self];
                }
            }];
            [alctr addAction:qrDetect];
        }
        [_viewController presentViewController:alctr animated:YES completion:nil];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imgView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x <= 0 || (scrollView.contentOffset.x + _imgView.frame.size.width) >= scrollView.contentSize.width - 1) {
        ((UIScrollView *)scrollView.superview).scrollEnabled = YES;
    } else {
        ((UIScrollView *)scrollView.superview).scrollEnabled = NO;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    _imgView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}

//#pragma mark - UIActionSheetDelegate
////- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
////{
////    if(actionSheet.tag == 123456 && buttonIndex == 0)
////    {
////        if (self.imgView.image)
////        {
////            UIImageWriteToSavedPhotosAlbum(self.imgView.image,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
////        }
////        else
////        {
////            KKMarkLog(@"image is nil");
////        }
////    }
////}
//
//-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
//{
//    if (error != NULL)
//    {
//        [KKProgressHUD showText:@"图片保存失败"];
//        KKMarkLog(@"%@", error);
//    }
//    else
//    {
//        [KKProgressHUD showText:@"图片保存成功"];
//    }
//}

@end
