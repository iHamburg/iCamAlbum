//
//  EditTextViewController.h
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 26.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "LabelModelView.h"
#import "TextViewController.h"

@class TextSettingViewController;

@interface EditTextViewController : TextViewController<UITextViewDelegate>{
	
	UITextView *tv;

	UIBarButtonItem *cancelBB, *doneBB;

    LabelModelView *_labelMV;
    
	TextSettingViewController *settingVC;
	
	CGFloat  displayedFontSize;
	NSString *fontName;
}


- (void)cancel;
//- (IBAction)segmentValueChanged:(id)sender;
//- (void)bgSliderDidChangValue:(float)newValue;

- (void)changeTextColor:(UIColor *)color;
- (void)changeBGColor:(UIColor *)color ;
- (void)changeFontName:(NSString *)fontName;
- (void)changeTextAlignment:(int)index;
- (void)changeBGAlpha:(float)newValue;
@end
