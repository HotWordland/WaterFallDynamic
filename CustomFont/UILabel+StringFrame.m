//
//  UILabel+StringFrame.m
//  CleverPharmaceutical
//
//  Created by Ronaldinho on 15/3/7.
//  Copyright (c) 2015年 HotWordLand. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)
- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:
                      NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attribute 
                                             context:nil].size; 
    return retSize; 
}
@end
