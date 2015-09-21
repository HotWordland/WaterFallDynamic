//
//  UIFont+CustomFont.h
//  FortyRobbers
//
//  Created by Ronaldinho on 14/9/17.
//  Copyright (c) 2014年 HotWordLand(文热大陆-巫龙). All rights reserved.
//
#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    systemfont,
    customfont,
} fontType;
#import <UIKit/UIKit.h>

@interface UIFont (CustomFont)
///加载自定义字体
+(UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size;
+(UIFont*)autoScaleFontSize:(CGFloat)size fontType:(fontType)fontType;

@end
