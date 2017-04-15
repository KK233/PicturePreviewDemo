//
//  KKPhotoMetaModel.m
//  EduChat
//
//  Created by KKK on 16/4/13.
//  Copyright © 2016年 KK. All rights reserved.
//

#import "KKPhotoMetaModel.h"

@implementation KKPhotoMetaModel


#pragma mark - /*****Public Method*****/

#pragma mark - 图片url
- (NSString *)thumbPhotoKey {
    /*** (其他图片)短边优先缩放 ***/
    return [self shorterPriorityPhotoKey:[self thumbSize]];
}

- (NSString *)chatThumbPhotoKey {
    /*** (聊天图片)长边优先缩放 ***/
    return [self longerPriorityPhotoKey:[self chatThumbSize]];
}

- (NSString *)originKey {
    return self.photoKey;
}

#pragma mark - 尺寸
/**
 像素 320 * 80
 点是 160 * 40
 */
- (CGSize)thumbSize {
    //短边为依据
    CGFloat photoWidth = self.width;
    CGFloat photoHeight = self.height;
    
    CGFloat scaleHeight;
    CGFloat scaleWidth;
    //sw = sh * w / h
    //sh = sw * h / w
    if (photoHeight > photoWidth) {
        //高 大于 宽
        scaleWidth = 160;
        scaleHeight = 160 / photoWidth * photoHeight;
        if (scaleWidth == 0 || isnan(scaleWidth)) {
            scaleWidth = scaleHeight;
        }
    } else {
        //高 小于等于 宽
        scaleHeight = 160;
        scaleWidth = 160 / photoHeight * photoWidth;
        if (scaleHeight == 0 || isnan(scaleHeight)) {
            scaleHeight = scaleWidth;
        }
    }
    
    return (CGSize){scaleWidth, scaleHeight};
}

- (CGSize)chatThumbSize {
    //宽 等于 高 的情况可以随意
    //        当高>宽时
    //        （1）高/宽>320/80,宽度等比拉伸到80，截取中间部分，显示80x320的缩略图
    //        （2）高/宽<320/80,高度等比拉伸到320，直接显示，显示 某个大于80小于320的数x 320
    //        当高<宽时
    //        （1）宽/高>320/80,高度等比拉伸到80，截取中间部分，显示320x80的缩略图
    //        （2）宽/高<320/80,宽度等比拉伸到320，，直接显示，显示320x某个大于80小于320的数
    
    //sw = sh * w / h
    //sh = sw * h / w
    
    CGFloat photoWidth = self.width;
    CGFloat photoHeight = self.height;

    
    CGFloat scaleHeight;
    CGFloat scaleWidth;
    
    //长边优先
    if (photoHeight > photoWidth) {
        //高 大于 宽
        if (photoHeight / photoWidth > 4.0) {
            scaleWidth = 40;
            scaleHeight = 40 / photoWidth * photoHeight;
            if (scaleHeight == 0 || isnan(scaleHeight)) {
                scaleHeight = scaleWidth;
            }
        } else {
            scaleHeight = 160;
            scaleWidth = 160 / photoHeight * photoWidth;
            if (scaleWidth == 0 || isnan(scaleWidth)) {
                scaleWidth = scaleHeight;
            }
        }
    } else {
        //高 小于等于 宽
        if (photoWidth / photoHeight > 4.0) {
            scaleHeight = 40;
            scaleWidth = 40 / photoHeight * photoWidth;
            if (scaleWidth == 0 || isnan(scaleWidth)) {
                scaleWidth = scaleHeight;
            }
        } else {
            scaleWidth = 160;
            scaleHeight = 160 / photoWidth * photoHeight;
            if (scaleHeight == 0 || isnan(scaleHeight)) {
                scaleHeight =scaleWidth;
            }
        }
    }
    
    
    return (CGSize){scaleWidth, scaleHeight};
}

#pragma mark - Private Method
/*****************************************
 w
 指定目标缩略图的宽度
 1-4096
 
 h
 指定目标缩略图的高度。
 1-4096
 
 e
 缩放优先边, 默认值:0:长边 (默认值) 
 由于图片缩放过程 中,原图尺寸与缩放尺寸不一定 是相同比例,需要指定以长边还 是短边优先进行缩放
 如原图 200 * 400(比例1:2),需要缩 放为100 * 100(比例1:1).
 长边 优先时,缩放为50 100;
 短边 优先时(e=1),缩放为`100 200`
 若不特别指定,则代表长 边优先
 0表示按长边优先,默认值 1表示按短边优先
 
 l
 目标缩略图大于原图是否处理。 
 如果值是1, 即不处理,是0,表示处理0/1, 默认是0
 ****************************************/

/**
 *  以宽度为基准拼接图片名
 *
 *  @return 图片url的string形式(xxx.jpg@100w
 */
- (NSString *)longerPriorityPhotoKey:(CGSize)size {
//    NSString *imgKey = [self.photoKey imgKey];
//    imgKey = [imgKey stringByAppendingString:[NSString stringWithFormat:@"@%dw_%dh_0e_80Q", (int)size.width * 2, (int)size.height * 2]];
////    KKMarkLog(@"长边优先photoKey:%@", imgKey);
//    return imgKey;
    return self.photoKey;
}

/**
 *  以高度为基准拼接图片名
 *
 *  @return 图片url的string形式(xxx.jpg@100h
 */
- (NSString *)shorterPriorityPhotoKey:(CGSize)size {
//    NSString *imgKey = [self.photoKey imgKey];
//    imgKey = [imgKey stringByAppendingString:[NSString stringWithFormat:@"@%dw_%dh_1e_80Q", (int)size.width, (int)size.height]];
////    photokey
////    photoMeta {photokey:, width:, height:};
//    
//    KKMarkLog(@"短边优先photoKey:%@", imgKey);
//    return imgKey;
    return self.photoKey;
}

#pragma mark - NSCoding

//@property (nonatomic, copy) NSString *photoKey;
//@property (nonatomic, assign) CGFloat width;
//@property (nonatomic, assign) CGFloat height;
//@property (nonatomic, assign) CGFloat size;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.photoKey forKey:@"photoKey"];
    [aCoder encodeFloat:self.width forKey:@"width"];
    [aCoder encodeFloat:self.height forKey:@"height"];
    [aCoder encodeFloat:self.size forKey:@"size"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    self.photoKey = [aDecoder decodeObjectForKey:@"photoKey"];
    self.width = [aDecoder decodeFloatForKey:@"width"];
    self.height = [aDecoder decodeFloatForKey:@"height"];
    self.size = [aDecoder decodeFloatForKey:@"size"];
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    KKPhotoMetaModel *model = [[KKPhotoMetaModel allocWithZone:zone] init];
    model.photoKey = self.photoKey;
    model.width = self.width;
    model.height = self.height;
    model.size = self.size;
    return self;
}

@end
