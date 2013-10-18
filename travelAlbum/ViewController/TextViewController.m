//
//  TextViewController.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-12.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "TextViewController.h"

@implementation TextViewController

- (void)loadView{
   
	CGFloat height = 288;
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WTEXTVC, height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
