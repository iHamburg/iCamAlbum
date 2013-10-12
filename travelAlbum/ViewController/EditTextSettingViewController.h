//
//  EditTextSettingViewController.h
//  Everalbum
//
//  Created by AppDevelopper on 03.01.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditTextViewController.h"


typedef enum {
	SettingColorModeText,
	SettingColorModeBG
}SettingColorMode; ///选择背景或文字的不同颜色

@interface EditTextSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

	FontScrollView *fontV;
	UIViewController *fontVC;
	MyColorPlatteView *colorPlatteV;
	UIViewController *colorPlatteVC;
	
	UITableView *tv;
	UISlider *bgAlphaSlider;
	UISegmentedControl *textAlignSeg;
	UISwitch *strokeSwitch;
	
	NSArray *tableKeys;
	NSArray *tableHeaders;


	NSString *textFontName;
	UIColor *textColor, *bgColor;
	float bgalpha, strokeWidthF; //0 - 1
	NSTextAlignment textAlignment;
	
}


@property (nonatomic, unsafe_unretained) EditTextViewController *parent;

@property (nonatomic, strong) LabelModelView *labelMV;

@property (nonatomic, strong) UISlider *bgAlphaSlider;
@property (nonatomic, strong) UISwitch *strokeSwitch;
@property (nonatomic, strong) NSString *textFontName;
@property (nonatomic, strong) UIColor *textColor, *bgColor;
@property (nonatomic, assign) float bgalpha;;
@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, assign) SettingColorMode colorMode;
- (void)popBack;
- (void)reload;

@end
