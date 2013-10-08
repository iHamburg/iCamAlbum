//
//  CommandAlertView.h
//  Everalbum
//
//  Created by AppDevelopper on 13-8-27.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Command;
@interface CommandAlertView : UIAlertView<UIAlertViewDelegate>


@property (nonatomic, strong) Command *command;
@end
