//
//  IndicatorView.m
//  Everalbum
//
//  Created by AppDevelopper on 13-8-22.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "IndicatorView.h"
#import "Macros.h"

@implementation IndicatorView{
    UIImageView *imgV;
    UILabel *label;
}

- (void)setImage:(UIImage *)image{
    imgV.image = image;
}

- (void)setText:(NSString *)text{
    label.text = text;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imgV = [[UIImageView alloc]initWithFrame:self.bounds];
        imgV.autoresizingMask = kAutoResize;
        
        label = [[UILabel alloc]initWithFrame:self.bounds];
        label.autoresizingMask = kAutoResize;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:isPad?26:12];
        
        [self addSubview:imgV];
        [self addSubview:label];
        
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

@end
