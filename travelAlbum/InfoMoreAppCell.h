//
//  InfoMoreAppCell.h
//  Everalbum
//
//  Created by AppDevelopper on 13-9-3.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoViewController.h"
#define kHeightInfoMoreAppCell (isPad?250:140)

@interface InfoMoreAppCell : UITableViewCell

@property (nonatomic, unsafe_unretained) InfoViewController *infoVC;
@property (nonatomic, strong) NSArray *moreApps;

@end
