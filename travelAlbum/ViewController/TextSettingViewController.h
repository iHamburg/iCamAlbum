//
//  TextSettingViewController.h
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-12.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTextViewController.h"
#import "LineScrollView.h"

@interface TextSettingViewController : UIViewController<LineScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{

    UITableView *tv;
        
    LineScrollView *fontLSV;
    LineScrollView *textColorLSV;
    LineScrollView *bgColorLSV;
    

    UISlider *bgAlphaSlider;
    UISegmentedControl *textAlignSeg;

    
    NSArray *sections;
    __unsafe_unretained EditTextViewController *_parent;
}

@property (nonatomic, unsafe_unretained) EditTextViewController *parent;

@end
