//
//  PaddingLabel.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-9-27.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "PaddingLabel.h"

@implementation PaddingLabel

@synthesize insets;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       insets = UIEdgeInsetsMake(0, kIsPad2*5, 0, kIsPad2 *5);
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)drawTextInRect:(CGRect)rect{
//    UIEdgeInsets insets = {0, 5, 0, 5};
    
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
