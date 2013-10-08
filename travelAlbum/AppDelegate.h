//
//  AppDelegate.h
//  travelAlbum
//
//  Created by  on 17.05.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FacebookManager.h"


@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, strong) Facebook *facebook;
@end
