//
//  CustomLabelWithNumAndEnglish.m
//  FortyRobbers
//
//  Created by Ronaldinho on 14/9/17.
//  Copyright (c) 2014年 HotWordLand(文热大陆-巫龙). All rights reserved.
//
#define MY_CUSTOM_FONT_CHINESE [UIFont customFontWithPath:[[NSBundle mainBundle] pathForResource:@"Yuanti" ofType:@"ttf"] size:18.f]

#import "CustomLabelWithChinese.h"
#import "UIFont+CustomFont.h"
@implementation CustomLabelWithChinese

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFont:[UIFont customFontWithPath:[[NSBundle mainBundle] pathForResource:@"Yuanti" ofType:@"ttf"] size:self.size.floatValue]];
        [self setAdjustsFontSizeToFitWidth:YES];

    }
    return self;
}
-(void)awakeFromNib
{
    [self setFont:[UIFont customFontWithPath:[[NSBundle mainBundle] pathForResource:@"Yuanti" ofType:@"ttf"] size:self.size.floatValue]];
    [self setAdjustsFontSizeToFitWidth:YES];
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
