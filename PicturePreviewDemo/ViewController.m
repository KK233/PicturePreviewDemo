//
//  ViewController.m
//  PicturePreviewDemo
//
//  Created by 张琰博 on 2017/4/15.
//  Copyright © 2017年 KKK. All rights reserved.
//

#import "ViewController.h"
#import "KKImagesScrollView.h"
#import "KKPhotoMetaModel.h"

#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *imagesArray;

@end

@implementation ViewController


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 模拟数据
    KKPhotoMetaModel *model0 = [KKPhotoMetaModel new];
    model0.photoKey = @"http://wx4.sinaimg.cn/mw690/76c73f8dly1fdtn19cyz9j20zk0npn5f.jpg";
    model0.width = 690;
    model0.height = 460;
    
    KKPhotoMetaModel *model1 = [KKPhotoMetaModel new];
    model1.photoKey = @"http://ww2.sinaimg.cn/large/7fea0255jw1f1s7aesmlvj215o1jkdw3.jpg";
    model1.width = 1500;
    model1.height = 2000;
    
    KKPhotoMetaModel *model2 = [KKPhotoMetaModel new];
    model2.photoKey = @"http://ww4.sinaimg.cn/large/7fea0255jw1f71ml4785hj215o1jkh4u.jpg";
    model2.width = 1500;
    model2.height = 2000;
    
    KKPhotoMetaModel *model3 = [KKPhotoMetaModel new];
    model3.photoKey = @"http://wx3.sinaimg.cn/mw690/76c73f8dly1fdtn93woxdj20v00hh4qp.jpg";
    model3.width = 690;
    model3.height = 389;
    
    _imagesArray = @[model0, model1, model2, model3];
    
    // 创建一个Collectionview用于demo
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 20;
    layout.itemSize = (CGSize){100, 100};
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor redColor];
    collectionView.frame = CGRectOffset(self.view.bounds, 0, 100);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    
//    打开展示进度条, 实际应用场景中, 缩略图和正常图不是一张图片
//    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
//    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    
    KKImagesScrollView *scrollView = [[KKImagesScrollView alloc] initWithPhotoMetaArray:_imagesArray];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    
    [scrollView presentViewFromImageView:[cell.contentView.subviews lastObject] atIndex:indexPath.item toContainer:self.view];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.frame = (CGRect){0, 0, 100, 100};
    [cell.contentView addSubview:imageView];
    
    NSLog(@"%@", ((KKPhotoMetaModel *)_imagesArray[indexPath.item]).photoKey);
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:((KKPhotoMetaModel *)_imagesArray[indexPath.item]).photoKey]];
    
    return cell;
}

@end
