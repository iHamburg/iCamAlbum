//
//  EditTextViewController.m
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 26.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

/**
 
 text font, ->
 text color, ->
 bg color    ->
 bg alpha : slide
 stroke width  3选一
 
 
 */

#import "ICATextViewController.h"
#import "TextSettingViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation ICATextViewController

- (void)setLabel:(LabelModelView *)label{
    
    _label = label;
    _labelMV = label;
    [self setupLMV];
}



- (void)setupLMV{
	tv.text = _labelMV.text;
	tv.textColor = _labelMV.textColor;
	tv.textAlignment = _labelMV.textAlignment;
	tv.font = [UIFont fontWithName:_labelMV.fontName size:displayedFontSize];
	tv.backgroundColor = [_labelMV.bgColor colorWithAlpha:_labelMV.bgAlpha];
	
    text = _labelMV.text;
    textColor = _labelMV.textColor;
    textAlignment = _labelMV.textAlignment;
    fontName = _labelMV.fontName;
    bgColor = _labelMV.bgColor;
    bgAlpha = _labelMV.bgAlpha;
    

}



- (void)done{
	CGFloat originalFontSize = _labelMV.font.pointSize;
//	NSLog(@"settingVC.bgalpha # %f",settingVC.bgalpha);
    
	_labelMV.text = tv.text;
	_labelMV.textColor = tv.textColor;
	_labelMV.font = [UIFont fontWithName:tv.font.fontName size:displayedFontSize];
	_labelMV.textAlignment = tv.textAlignment;
    _labelMV.fontName = fontName;
    _labelMV.bgColor = bgColor;
    _labelMV.bgAlpha = bgAlpha;
    
 
	
	//  现在fontsize 30的时候确定textwidget的bounds和faktor，然后扩大font和bounds！
	//
	CGSize sizeWith30 = [_labelMV sizeThatFits:CGSizeMake(tv.bounds.size.width, 100000)];
	
	_labelMV.fontSizeFaktor = displayedFontSize/sizeWith30.width;
	
	CGFloat enhanceFaktor = originalFontSize/displayedFontSize;
	
	_labelMV.bounds = CGRectMake(0, 0, sizeWith30.width*enhanceFaktor, sizeWith30.height*enhanceFaktor);
	
	_labelMV.font = [UIFont fontWithName:_labelMV.fontName size:originalFontSize];
	
    NSLog(@"label.font # %@, fontName # %@",_labelMV.font, _labelMV.fontName);
    
    [_delegate textVCDidChangeLabel:_labelMV];

}
@end
