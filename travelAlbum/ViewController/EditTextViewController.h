//
//  EditTextViewController.h
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 26.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumEditViewController.h"
#import "FontScrollView.h"
#import "LabelModelView.h"
#import "MyColorPlatteView.h"

@class EditTextSettingViewController;

@interface EditTextViewController : UIViewController<UITextViewDelegate,MyColorPlatteDelegate, FontScrollViewDelegate>{
	
	UIView *editContainer;
	
	UITextView *tv;
	UIButton *keyboardReturnB;
	UIBarButtonItem *backBB, *cancelBB, *doneBB, *optionBB;

	MyColorPlatteView *colorPlatteV;
	FontScrollView *fontV;
	EditTextSettingViewController *settingVC;
	UINavigationController *settingNav;
	
	CGFloat  displayedFontSize;
	NSString *fontName;
}


@property (nonatomic, unsafe_unretained) AlbumEditViewController *vc;
@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) LabelModelView *labelMV;

- (void)cancel;
- (void)settingBack;
- (void)settingDidPush;
- (IBAction)segmentValueChanged:(id)sender;
- (void)bgSliderDidChangValue:(float)newValue;

- (void)pushSetting_phone;
@end
