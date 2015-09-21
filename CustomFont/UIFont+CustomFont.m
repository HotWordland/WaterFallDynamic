//
//  UIFont+CustomFont.m
//  FortyRobbers
//
//  Created by Ronaldinho on 14/9/17.
//  Copyright (c) 2014年 HotWordLand(文热大陆-巫龙). All rights reserved.
//
#import "UIFont+CustomFont.h"
#import <CoreText/CoreText.h>
#import "DeviceJudge.h"
#define CUSTOM_FONT_BYSIZE(FONT_SIZE) [UIFont customFontWithPath:[[NSBundle mainBundle] pathForResource:@"Yuanti" ofType:@"ttf"] size:FONT_SIZE]
@implementation UIFont (CustomFont)
///加载自定义字体
+(UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size
{
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}
+(UIFont*)autoScaleFontSize:(CGFloat)size fontType:(fontType)fontType
{
    switch (fontType) {
        case systemfont:
        {
            switch ([DeviceJudge currentResolution]) {
                case iPhone6HiRes:
                {
                    return  [UIFont systemFontOfSize:size+5];

                }
                    break;
                    case iPhone6PlusHiRes:
                {
                    return  [UIFont systemFontOfSize:size+10];

                }
                    break;
                    
                default:
                {
                    return  [UIFont systemFontOfSize:size];

                }
                    break;
            }
        }
            break;
             case customfont:
        {
            switch ([DeviceJudge currentResolution]) {
                case iPhone6HiRes:
                {
                 return CUSTOM_FONT_BYSIZE(size+5);
                    
                }
                    break;
                case iPhone6PlusHiRes:
                {
                    return  CUSTOM_FONT_BYSIZE(size+10);
                    
                }
                    break;
                    
                default:
                {
                    return  CUSTOM_FONT_BYSIZE(size);
                    
                }
                    break;
            }

        }
            break;
        default:
        {
            return [UIFont systemFontOfSize:size];
        }
            break;
    }
  }

@end
