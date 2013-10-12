//
//  AppViewController.h
//  XappTravelAlbum_0_2
//
//  Created by  on 28.03.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICARootViewController.h"
#import "AlbumManager.h"
#import "MomentManager.h"
#import "AdView.h"

@interface AppViewController : UIViewController<UIAlertViewDelegate>{

	
	UIImageView *bgV;

	AlbumManager *manager;
    MomentManager *_momentManager;
	ICARootViewController *root;
    Album *_album;

    
    UIPopoverController *pop;
}

@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) MomentManager *momentManager;


- (IBAction)buttonClicked:(id)sender;

- (void)registerNotifications;
- (void)unregisterNotifications;

- (void)layoutADBanner:(UIView*)banner;

- (void)test;
@end
