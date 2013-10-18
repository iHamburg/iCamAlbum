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

#import "EditTextViewController.h"
#import "TextSettingViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation EditTextViewController

- (void)setLabel:(LabelModelView *)label{
    
    _label = label;
    _labelMV = label;
    [self setupLMV];
}


- (void)loadView{
    [super loadView];
    
	self.view.backgroundColor = kColorDarkPattern2;
    
	doneBB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toolbarButtonClicked:)];
	cancelBB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(toolbarButtonClicked:)];
	
	
	
	self.navigationItem.rightBarButtonItem = doneBB;
    self.navigationItem.leftBarButtonItem = cancelBB;

	self.title = STextVCTitle;
	
    displayedFontSize = isPad?30:20;
 
    
	CGFloat hTextView = isPad?self.view.height:125;
    CGFloat yOrigin = (isPhone&&isIOS7)?kHNavigationbar:0;
    
	tv = [[UITextView alloc]initWithFrame:CGRectMake(self.view.width/2, yOrigin, self.view.width/2, hTextView)];
	tv.layer.borderColor = [UIColor blackColor].CGColor;
	tv.layer.borderWidth = 2.0;
	tv.delegate = self;
	tv.layer.cornerRadius = 10;
	tv.backgroundColor = [UIColor clearColor];
    
	settingVC = [[TextSettingViewController alloc]init];
    settingVC.parent = self;
	settingVC.view.alpha = 1;
    settingVC.view.frame = CGRectMake(0, yOrigin, self.view.width/2, hTextView);
	
    [self.view addSubview:settingVC.view];
	[self.view addSubview:tv];

    
    
    //    backBB = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarButtonClicked:)];
    //	optionBB = [[UIBarButtonItem alloc]initWithTitle:@"Option" style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarButtonClicked:)];
	

}

// reset tv: text, color, font
/*
 要注意的是fontName和font.fontName不是一个东西，
 我们保存的是fontname和fontsize
 
 */


- (void)setupLMV{
	tv.text = _labelMV.text;
	tv.textColor = _labelMV.textColor;
	tv.textAlignment = _labelMV.textAlignment;
	tv.font = [UIFont fontWithName:_labelMV.fontName size:displayedFontSize];
	tv.backgroundColor = [_labelMV.bgColor colorWithAlpha:_labelMV.bgAlpha];
	
//	settingVC.labelMV = _labelMV;

}

- (void)viewWillAppear:(BOOL)animated{

	
	[super viewWillAppear:animated];

    [tv becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{

	[super viewDidAppear:animated];

//	[tv becomeFirstResponder];
    tv.contentOffset = CGPointZero;
    
//    NSLog(@"textVC # %@,textV: # %@",self.view,tv);

}

- (void)viewWillDisappear:(BOOL)animated{
	
	[super viewWillDisappear:animated];
	
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (NSUInteger)supportedInterfaceOrientations{
    
	return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - IBOutlet
- (IBAction)toolbarButtonClicked:(id)sender{
	
	if(sender == cancelBB){
		[self cancel];
	}
	else if(sender == doneBB){
		[self done];
	}
//	else if(sender == backBB){
//		[self settingBack];
//	}
//	else if(sender == optionBB){
//		[self pushSetting_phone];
//	}
//	else if(sender == keyboardReturnB){
//		[tv resignFirstResponder];
//		[keyboardReturnB removeFromSuperview];
//	}
}
//
//#pragma mark - Keyboard
//- (void)keyboardWillShow:(NSNotification *)note {
//	
//	
//		UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
//		[self performSelector:@selector(showDoneButton:) withObject:tempWindow afterDelay:0.6];
//
//	
//}
//
//- (void)showDoneButton:(UIView*)supV{
//	[supV addSubview:keyboardReturnB];
//	
//}
//

#pragma mark - Segment


- (void)segmentValueChanged:(UISegmentedControl*)seg{
//	NSLog(@"seg.value # %d",textAlignSeg.selectedSegmentIndex);
	int index = seg.selectedSegmentIndex;
	[self changeTextAlignment:index];
}

//#pragma mark - Slider
//
//
//
//- (void)bgSliderDidChangValue:(float)newValue{
//    
//    
//    [self changeBGAlpha:newValue];
//}
#pragma mark - Navigation
//pad
//- (void)settingBack{
//	if (isPad) {
//		self.navigationItem.leftBarButtonItem = cancelBB;
//		[settingVC popBack];
//	}
//		
//}

//pad
//- (void)settingDidPush{
//	if (isPad) {
//		self.navigationItem.leftBarButtonItem = backBB;
//	}
//
//}

//phone
//- (void)pushSetting_phone{
//
//	if (!settingVC) {
//		settingVC = [[EditTextSettingViewController alloc]init];
//		settingVC.view.alpha = 1;
//		settingVC.parent = self;
//	}
//	
//	[self.navigationController pushViewController:settingVC animated:YES];
//}

//pad
- (void)cancel{

//	[settingVC popBack];
//	[keyboardReturnB removeFromSuperview];
	
//    [vc closeTextEdit];

    [_delegate textVCDidCancel:self];
}


- (void)done{
	CGFloat originalFontSize = _labelMV.font.pointSize;
//	NSLog(@"settingVC.bgalpha # %f",settingVC.bgalpha);
    
	_labelMV.text = tv.text;
	_labelMV.textColor = tv.textColor;
	_labelMV.font = [UIFont fontWithName:tv.font.fontName size:displayedFontSize];
	_labelMV.textAlignment = tv.textAlignment;
//    _labelMV.fontName = settingVC.textFontName;
//	_labelMV.bgColor = settingVC.bgColor;
//	_labelMV.bgAlpha = settingVC.bgalpha;
//	if (settingVC.strokeSwitch.on) {
//		_labelMV.strokeColor = [UIColor whiteColor];
//	}
//	else{
//		_labelMV.strokeColor = nil;
//	}
	
	//  现在fontsize 30的时候确定textwidget的bounds和faktor，然后扩大font和bounds！
	//
	CGSize sizeWith30 = [_labelMV sizeThatFits:CGSizeMake(tv.bounds.size.width, 100000)];
	
	_labelMV.fontSizeFaktor = displayedFontSize/sizeWith30.width;
	
	CGFloat enhanceFaktor = originalFontSize/displayedFontSize;
	
	_labelMV.bounds = CGRectMake(0, 0, sizeWith30.width*enhanceFaktor, sizeWith30.height*enhanceFaktor);
	
	_labelMV.font = [UIFont fontWithName:_labelMV.fontName size:originalFontSize];
	
    NSLog(@"label.font # %@, fontName # %@",_labelMV.font, _labelMV.fontName);
    
//    [settingVC popBack];
//	[keyboardReturnB removeFromSuperview];

    [_delegate textVCDidChangeLabel:_labelMV];

}

#pragma mark - Function
- (void)changeTextColor:(UIColor *)color {
//    settingVC.textColor = color;
    tv.textColor = color;
//    [settingVC reload];
}

- (void)changeBGColor:(UIColor *)color {
//    settingVC.bgColor = color;
//    tv.backgroundColor = [color colorWithAlpha:settingVC.bgalpha];
    
//    [settingVC reload];
}

- (void)changeFontName:(NSString *)fontName_ {
    fontName = fontName_;
    
    float fontSize = tv.font.pointSize;
	tv.font = [UIFont fontWithName:fontName size:fontSize];
	
}

- (void)changeTextAlignment:(int)index {
    if (index == 0) {
		tv.textAlignment = NSTextAlignmentLeft;
	}
	else if(index == 1){
		tv.textAlignment = NSTextAlignmentCenter;
	}
	else if (index == 2){
		tv.textAlignment = NSTextAlignmentRight;
	}
}

- (void)changeBGAlpha:(float)newValue {
//    tv.backgroundColor = [settingVC.bgColor colorWithAlpha:newValue];
    
}
@end
