//
//  KKPhotoMetaModel.h
//  EduChat
//
//  Created by KKK on 16/4/13.
//  Copyright © 2016年 KK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KKPhotoMetaModel : NSObject <NSCopying, NSCoding>

@property (nonatomic, copy) NSString *photoKey;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat size;

/**
 *  缩略图地址 (短边优先
 *
 *  @return 缩略图photoKey
 */
- (NSString *)thumbPhotoKey;

/**
 *  缩略图尺寸 (短边优先
 *
 *  @return 缩略图尺寸
 */
- (CGSize)thumbSize;

/**
 *  聊天图片缩略图地址 (长边优先缩放
 *
 *  @return 缩略图photoKey
 */
- (NSString *)chatThumbPhotoKey;

/**
 *  聊天缩略图尺寸(长边优先缩放
 *
 *  @return 缩略图尺寸
 */
- (CGSize)chatThumbSize;

/**
 *  获取原图地址
 *
 *  @return 原图photoKey
 */
- (NSString *)originKey;

@end
