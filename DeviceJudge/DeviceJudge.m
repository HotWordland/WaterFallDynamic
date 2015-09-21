//
//  DeviceJudge.m
//  CleverPharmaceutical
// 设备判定
//  Created by Ronaldinho on 15/1/19.
//  Copyright (c) 2015年 HotWordLand. All rights reserved.
//

#import "DeviceJudge.h"

@implementation DeviceJudge
+(UIDeviceResolution)currentResolution{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
            if (result.height == 1334) {
                return iPhone6HiRes;
            }
            else if (result.height == 2208) return iPhone6PlusHiRes;
            if (result.height <= 480.0f)
                return UIDevice_iPhoneStandardRes;
            return (result.height > 960 ? iPhone5_5SHiRes : iPhone4_4SHiRes);
        } else
            return UIDevice_iPhoneStandardRes;
    } else
        return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) ? UIDevice_iPadHiRes : UIDevice_iPadStandardRes);
}

@end
