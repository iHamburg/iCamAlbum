//
//  ColorLineScrollView.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-12.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "ColorLineScrollView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ColorLineScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        colorHexes = @[@"ffffff",@"d1d1d1",@"9b9ba1",@"434343", //black and white
                       @"e33135",@"8f3530",@"6b5f53",@"707f44", //green
                       @"c3a982",@"684934",@"6B9A32",@"b4dbcb", //red
                       @"1b3e5d",@"80b4c1",@"bbd1d6",@"c5cedd", //blue
                       @"babaad",@"a28eb4",@"5a4068",@"605861", //yellow
                       @"e6d6bb",@"ddb676",@"af7f49",@"f6ce70", //other
                       @"eb7842",@"fdbfa8",@"564d83",@"9b6950", //yellow
                       @"e4f2f2",@"90aeb8",@"b38f77",@"dbcdbd", //other
                       ];
        
        
        int count = [colorHexes count];
        CGFloat wL = self.height - 2;
        CGFloat hL = self.height - 2;
        CGFloat offset = 5;
        for (int i = 0; i < count; i++) {
            UIView *l = [[UIView alloc] initWithFrame:CGRectMake(i *(wL + offset), 2, wL, hL)];
            l.layer.cornerRadius = 5;
            l.backgroundColor = [UIColor colorWithHEX:colorHexes[i]];
            l.userInteractionEnabled = YES;
            [l addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
            [self addSubview:l];
            self.contentSize = CGSizeMake(CGRectGetMaxX(l.frame), 0);
        }
        

    }
    return self;
}


@end
