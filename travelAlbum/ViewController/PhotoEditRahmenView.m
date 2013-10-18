//
//  PhotoEditRahmenView.m
//  InstaMagazine
//
//  Created by XC  on 10/27/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "PhotoEditRahmenView.h"

@implementation PhotoEditRahmenView

@synthesize parent;

/**
 
 height: iPad: 100, iphone:50
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGFloat imgW = isPad?60:40;
        CGFloat margin = isPad?20:10;
        
		self.backgroundColor = [UIColor clearColor];
		
        imgVs = [NSMutableArray array];
       

        _rahmenColors = [self createRahmenColors];
        
        UIImage *thumbImg = [UIImage imageNamed:@"DSFilterTileNormal.png"];
		CGFloat hMargin = isPad?20:5;
        for (int i = 0; i<[_rahmenColors count]+1  ; i++) {
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(margin+ (imgW+margin) *i, hMargin, imgW, imgW)];
            imgV.tag = i+1;
            imgV.userInteractionEnabled = YES;
            imgV.image = thumbImg;
            imgV.layer.cornerRadius = isPad?8:4;
			imgV.layer.masksToBounds = YES;
            [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
            [imgVs addObject:imgV];
            
            if (i>0) {
                UIColor *color = _rahmenColors[i-1];
				imgV.layer.borderWidth = isPad?5:3;
                imgV.layer.borderColor = color.CGColor;
               
            }
            
            [self addSubview:imgV];
            
        }
        
        self.contentSize = CGSizeMake((imgW+margin)*([imgVs count]+1), 0);

        selectedIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        selectedIcon.image = [UIImage imageNamed:@"icon_selected.png"];
    }
    return self;
}

- (void)setup{
	L();
    [selectedIcon removeFromSuperview];
}

- (void)handleTap:(UITapGestureRecognizer*)tap{
    
    UIView *v = [tap view];
    
    selectedIcon.center = CGPointMake(CGRectGetMaxX(v.bounds)-10, CGRectGetMinY(v.bounds)+10);
    [v addSubview:selectedIcon];
    
    int colorIndex = v.tag -2;

    UIColor *color;
    if (colorIndex>=0) {
        color = _rahmenColors[colorIndex];
    }
    
    [parent applyRahmenColor:color];
}

- (NSArray*)createRahmenColors{
    
    // Color Rahmen
    NSArray *rahmenColorStrs = @[
                                 @"ffffff",@"b5b5b5",@"575757",@"000000", //black and white
                                 @"c8ebb1",@"9bcc94",@"689864",@"405e0d", //green
                                 @"d14a89",@"ff6501",@"993303",@"673303", //red
                                 @"c7ddf5",@"91ceff",@"669acc",@"336799", //blue
                                 @"fff7ce",@"ffff66",@"ce9834",@"9a660d", //yellow
                                 @"8abcb9",@"fdc975",@"319ea1",@"ff945a", //other
                                 ];
    NSMutableArray *colors = [NSMutableArray array];
    for (NSString *str in rahmenColorStrs) {
        UIColor *color = [UIColor colorWithHEX:str];
        [colors addObject:color];
    }
    return colors;
}
@end
