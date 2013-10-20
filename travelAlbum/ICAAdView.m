//
//  ICAAdView.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-13.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "ICAAdView.h"
#import "ICARootViewController.h"

@implementation ICAAdView

+ (id)sharedInstance{
    
    if (isPaid() || isIAPFullVersion) {
        return nil;
    }
    
    if (sharedInstance == nil) {
		CGFloat hBanner = isPad?66:32;
		sharedInstance = [[[self class] alloc]initWithFrame:CGRectMake(0, _h, _w, hBanner)];
	}
	
	return sharedInstance;
}
- (id)initWithFrame:(CGRect)frame
{
     _root = [ICARootViewController sharedInstance];
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (BOOL)isPaidVersion{

    NSLog(@"isPaid? # %d",isPaid());
    return isPaid();

}

@end
