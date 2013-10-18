//
//  LineScrollView.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-12.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "LineScrollView.h"

@implementation LineScrollView


- (IBAction)handleTap:(UITapGestureRecognizer*)sender{
    
    UIView *v = [sender view];
    
    [_lineDelegate lineScrollView:self didSelectView:v];
}
@end
