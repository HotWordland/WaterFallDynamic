//
//  DeviceJudge.h
//  CleverPharmaceutical
//
//  Created by Ronaldinho on 15/1/19.
//  Copyright (c) 2015年 HotWordLand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
enum {
    // iPhone 1,3,3GS 标准分辨率(320x480px)
    UIDevice_iPhoneStandardRes      = 1,
    // iPhone 4/4S 高清分辨率(640x960px)
    iPhone4_4SHiRes            = 2,
    // iPhone 5/5s 高清分辨率(640x1136px)
    iPhone5_5SHiRes      = 3,
    // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPadStandardRes        = 4,
    // iPad 3 High Resolution(2048x1536px)
    UIDevice_iPadHiRes              = 5,
    /** iphone6*/
    iPhone6HiRes                                    = 6,
    /** iphone6Plus*/
    iPhone6PlusHiRes              =7
}; typedef NSUInteger UIDeviceResolution;

@interface DeviceJudge : NSObject
/**
  获取当前设备型号(屏幕分辨率)
 */
+(UIDeviceResolution)currentResolution;
@end
