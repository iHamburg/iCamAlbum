//
//  FontNameLineScrollView.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-12.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "FontNameLineScrollView.h"

@implementation FontNameLineScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        fontNames = getAllFontNames();
        
        int count = [fontNames count];
        CGFloat wL = self.height*1.5;
        CGFloat hL = self.height;
        CGFloat offset = 5;
        for (int i = 0; i < count; i++) {
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(i *(wL + offset), 0, wL, hL)];

            l.text = @"Xappsoft";
            l.font = [UIFont fontWithName:fontNames[i] size:isPad?20:12];
            l.userInteractionEnabled = YES;
            l.backgroundColor = [UIColor clearColor];
            l.textAlignment = NSTextAlignmentCenter;
            [l addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
            [self addSubview:l];
            self.contentSize = CGSizeMake(CGRectGetMaxX(l.frame), 0);
            
        }
        

    }
    return self;
}



@end
