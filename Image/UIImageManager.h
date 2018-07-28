//
//  UIImageManager.h
//  CreateMovieByImage
//
//  处理图片的类
//  Created by roy on 2018/7/24.
//  Copyright © 2018年 Iceroy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageManager : NSObject

/**
 根据frame截屏

 @param frame 尺寸
 @return 截屏之后的UIImage
 */
-(UIImage*)createByFrame:(CGRect)frame;

/**
  根据文件头来生成名字,例如将 sdfsdfk.jpg sdfjlaf.jpg 生成  No1.jpg No2.jpg这样有顺序的文件名

 @param names 目前的文件名数组
 @param prefix 文件名头
 @param path 保存路径
 @param deleteOld 是否删除旧文件
 @return 文件名数组
 */
-(NSArray*)outputImages:(NSArray*)names prefix:(NSString*)prefix savePath:(NSString*)path deleteOld:(BOOL)deleteOld;
@end
