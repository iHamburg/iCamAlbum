//
//  iCAInstructionViewController.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-9.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "iCAInstructionViewController.h"

@implementation iCAInstructionViewController

- (void)loadView{
    [super loadView];
    
    numOfPages = 7;
    NSMutableArray *imgNames = [NSMutableArray arrayWithCapacity:numOfPages];
    for (int  i = 1; i<numOfPages+1; i++) {
        [imgNames addObject:[NSString stringWithFormat:@"instruction-story%d.jpg",i]];
    }
	
    CGFloat wImage = isPad?960:480;
    CGFloat hImage = isPad?640:320;
    
    for (int i = 0; i<numOfPages; i++) {
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake((_w-wImage)/2,_h*i + (_h-hImage)/2, wImage, hImage)];
        imgV.image = [UIImage imageWithSystemName:imgNames[i]];
        
        
        [scrollView addSubview:imgV];
        scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(imgV.frame));
    }
    
}

@end
