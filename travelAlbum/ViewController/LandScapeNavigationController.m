//
//  LandScapeNavigationController.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-9-27.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "LandScapeNavigationController.h"


@implementation LandScapeNavigationController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (NSUInteger)supportedInterfaceOrientations{
    
	return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}


@end
