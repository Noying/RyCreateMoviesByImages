//
//  RyCreateMovieByImage.h
//  CreateMovieByImage
//
//  Created by roy on 2018/7/24.
//  Copyright © 2018年 Iceroy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RyCreateMovieByImage : NSObject

@property(nonatomic) int height;
@property(nonatomic) int width;
@property(nonatomic) CGSize size;

/**
 设置图片列表，默认最后一张图片补全帧数

 @param images 图片组
 */
-(void)setImages:(NSArray*)images;

/**
 设置一秒内多少张图画，也就是帧数

 @param nums 帧数
 */
-(void)setMovieImagesNumInOneSecond:(NSInteger)nums;

/**
 产出视频

 @return 产出可以播放的视频
 */
-(id)createMoive;

/**
 保存视频

 @param urlPath  保存路径
 */
-(void)saveMoiveByPath:(NSString*)urlPath;

@end
