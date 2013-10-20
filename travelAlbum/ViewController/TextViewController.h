//
//  TextViewController.h
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-12.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WTEXTVC (isPad?780:_w)

@protocol TextVCDelegate;

@class TextSettingViewController;
@interface TextViewController : UIViewController<UITextViewDelegate>{
    
    UILabel *_label;
    
    UITextView *tv;
	UIBarButtonItem *cancelBB, *doneBB;
    

    
	TextSettingViewController *settingVC;
	
	CGFloat  displayedFontSize;
	
    NSString *fontName;
    NSString *text;
    UIColor *textColor;
    UIColor *bgColor;
    float bgAlpha;
    NSTextAlignment textAlignment;

    __unsafe_unretained id<TextVCDelegate> _delegate;
}

@property (nonatomic, unsafe_unretained) id<TextVCDelegate> delegate;
@property (nonatomic, strong) UILabel *label;

- (void)cancel;


- (void)changeTextColor:(UIColor *)color;
- (void)changeBGColor:(UIColor *)color ;
- (void)changeFontName:(NSString *)fontName;
- (void)changeTextAlignment:(int)index;
- (void)changeBGAlpha:(float)newValue;

@end


@protocol TextVCDelegate <NSObject>

- (void)textVCDidCancel:(TextViewController*)textVC;
- (void)textVCDidChangeLabel:(UILabel*)label;

@end
