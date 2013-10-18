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

- (id)initWithFrame:(CGRect)frame
{
     _root = [ICARootViewController sharedInstance];
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (BOOL)isPaidVersion{

    return isPaid();

}

@end
