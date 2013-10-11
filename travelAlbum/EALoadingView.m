//
//  EALoadingView.m
//  Everalbum
//
//  Created by AppDevelopper on 13-8-27.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "EALoadingView.h"
#import "UtilLib.h"
#import "ICARootViewController.h"
@implementation EALoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        window = [[ICARootViewController sharedInstance]view];
        loadingLabel.font = [UIFont fontWithName:kFontName size:isPad?18:14];
    }
    return self;
}



@end
