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
#import "EditTextSettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LandScapeNavigationController.h"

@implementation EditTextViewController

@synthesize vc;

- (UINavigationController*)nav{
    if (!_nav) {
        _nav = [[LandScapeNavigationController alloc]initWithRootViewController:self];
         _nav.view.frame = CGRectMake(0, 0, self.view.width, self.view.height + kHPopNavigationbar);
    }
    return _nav;
}

- (void)setLabelMV:(LabelModelView *)labelMV{
	_labelMV = labelMV;
	[self setupLMV];
}

- (void)loadView{
    CGFloat width = isPad?780:_w;
	CGFloat height = 288;
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
	self.view.backgroundColor = kColorDarkPattern2;
    
	doneBB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toolbarButtonClicked:)];
	cancelBB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(toolbarButtonClicked:)];
	backBB = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarButtonClicked:)];
	optionBB = [[UIBarButtonItem alloc]initWithTitle:@"Option" style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarButtonClicked:)];
	
	
	self.navigationItem.rightBarButtonItem = doneBB;
	
	self.title = @"Add Text";
    
	editContainer = [[UIView alloc]initWithFrame:self.view.bounds];
	
	displayedFontSize = isPad?30:20;
    
	CGFloat wScreen = _w;
    
	CGFloat wTextView = 400;
	CGFloat hTextView = isPad?height:100;
    
	CGRect tvRect = isPad?CGRectMake(370, 0, wTextView, hTextView):CGRectMake((wScreen-wTextView)/2, 0, wTextView, hTextView);
	tv = [[UITextView alloc]initWithFrame:tvRect];
	tv.text = @"abc";
	tv.layer.borderColor = [UIColor blackColor].CGColor;
	tv.layer.borderWidth = 2.0;
	tv.delegate = self;
	tv.layer.cornerRadius = 10;
	tv.backgroundColor = [UIColor clearColor];
	
	settingVC = [[EditTextSettingViewController alloc]init];
	settingVC.view.alpha = 1;
	settingVC.parent = self;
	
	
	if (isPad) {
        
		self.navigationItem.leftBarButtonItem = cancelBB;
		
		settingNav = [[UINavigationController alloc]initWithRootViewController:settingVC];
		settingNav.view.frame = CGRectMake(0, 0, settingVC.view.width, settingVC.view.height);
		settingNav.navigationBarHidden = YES;
		
		[editContainer addSubview:settingNav.view];
        
		
	}
	else{
        
		self.navigationItem.leftBarButtonItem = optionBB;
		
	}
    
	[editContainer addSubview:tv];
	[self.view addSubview:editContainer];
	
//    NSLog(@"textVC # %@,textV: # %@",self.view,tv);

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
	
	
	settingVC.labelMV = _labelMV;

}

- (void)viewWillAppear:(BOOL)animated{

	
	[super viewWillAppear:animated];

	if (isPhone) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification
												   object:nil];
	}

    if (isIOS7 && isPhone) {
//        for (UIView *subV in self.view.subviews) {
//            [subV moveOrigin:CGPointMake(0, kHNavigationbar)];
//        }
        [tv setOrigin:CGPointMake(tv.frame.origin.x, kHNavigationbar)];
    }
}

- (void)viewDidAppear:(BOOL)animated{

	[super viewDidAppear:animated];
	[tv becomeFirstResponder];

    tv.contentOffset = CGPointZero;
    
    NSLog(@"textVC # %@,textV: # %@",self.view,tv);

}

- (void)viewWillDisappear:(BOOL)animated{
	
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//	L();

	
	if(sender == cancelBB){
		[self cancel];
	}
	else if(sender == doneBB){
		[self done];
	}
	else if(sender == backBB){
		[self settingBack];
	}
	else if(sender == optionBB){
		[self pushSetting_phone];
	}
	else if(sender == keyboardReturnB){
		[tv resignFirstResponder];
		[keyboardReturnB removeFromSuperview];
	}
}

#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)note {
	
	
		UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
		[self performSelector:@selector(showDoneButton:) withObject:tempWindow afterDelay:0.6];

	
}

- (void)showDoneButton:(UIView*)supV{
	[supV addSubview:keyboardReturnB];
	

	
}


#pragma mark - Color
/**
 
 change the color of Textview
 
 */
- (void)colorPlatte:(MyColorPlatteView *)v didTapColor:(UIColor *)color{
	if (settingVC.colorMode == SettingColorModeText) {
		settingVC.textColor = color;

		
		tv.textColor = color;
		
		[settingVC reload];
	}
	else if(settingVC.colorMode == SettingColorModeBG){
		settingVC.bgColor = color;
		tv.backgroundColor = [color colorWithAlpha:settingVC.bgalpha];
		
		[settingVC reload];
	}
}

#pragma mark - FontScrollview

/**
 
 chagne the font of Textview
 */
//

- (void)fontScrollViewDidSelectedFontName:(NSString *)fontName_{
    fontName = fontName_;
    
    float fontSize = tv.font.pointSize;
	tv.font = [UIFont fontWithName:fontName size:fontSize];
	
	settingVC.textFontName = fontName;
	[settingVC reload];
}

#pragma mark - Segment

- (void)segmentValueChanged:(UISegmentedControl*)seg{
//	NSLog(@"seg.value # %d",textAlignSeg.selectedSegmentIndex);
	int index = seg.selectedSegmentIndex;
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

#pragma mark - Slider

- (void)bgSliderDidChangValue:(float)newValue{
    
    tv.backgroundColor = [settingVC.bgColor colorWithAlpha:newValue];
}
#pragma mark - Navigation
//pad
- (void)settingBack{
	if (isPad) {
		self.navigationItem.leftBarButtonItem = cancelBB;
		[settingVC popBack];
	}
		
}

//pad
- (void)settingDidPush{
	if (isPad) {
		self.navigationItem.leftBarButtonItem = backBB;
	}

}

//phone
- (void)pushSetting_phone{
	//	[settingVC ]
	if (!settingVC) {
		settingVC = [[EditTextSettingViewController alloc]init];
		settingVC.view.alpha = 1;
		settingVC.parent = self;
	}
	
	[self.navigationController pushViewController:settingVC animated:YES];
}

//pad
- (void)cancel{

	[settingVC popBack];
	[keyboardReturnB removeFromSuperview];
	
    [vc closeTextEdit];

}


- (void)done{
	CGFloat originalFontSize = _labelMV.font.pointSize;
	NSLog(@"settingVC.bgalpha # %f",settingVC.bgalpha);
    
	_labelMV.text = tv.text;
	_labelMV.textColor = tv.textColor;
	_labelMV.font = [UIFont fontWithName:tv.font.fontName size:displayedFontSize];
	_labelMV.textAlignment = tv.textAlignment;
    _labelMV.fontName = settingVC.textFontName;
	_labelMV.bgColor = settingVC.bgColor;
	_labelMV.bgAlpha = settingVC.bgalpha;
	if (settingVC.strokeSwitch.on) {
		_labelMV.strokeColor = [UIColor whiteColor];
	}
	else{
		_labelMV.strokeColor = nil;
	}
	
	//  现在fontsize 30的时候确定textwidget的bounds和faktor，然后扩大font和bounds！
	//
	CGSize sizeWith30 = [_labelMV sizeThatFits:CGSizeMake(tv.bounds.size.width, 100000)];
	
	_labelMV.fontSizeFaktor = displayedFontSize/sizeWith30.width;
	
	CGFloat enhanceFaktor = originalFontSize/displayedFontSize;
	
	_labelMV.bounds = CGRectMake(0, 0, sizeWith30.width*enhanceFaktor, sizeWith30.height*enhanceFaktor);
	
	_labelMV.font = [UIFont fontWithName:_labelMV.fontName size:originalFontSize];
	
    NSLog(@"label.font # %@, fontName # %@",_labelMV.font, _labelMV.fontName);
    
    [settingVC popBack];
	[keyboardReturnB removeFromSuperview];

	[vc finishTextEdit:_labelMV];
	

}
@end
