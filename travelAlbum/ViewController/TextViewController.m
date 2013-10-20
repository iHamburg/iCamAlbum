//
//  TextViewController.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-12.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "TextViewController.h"
#import "TextSettingViewController.h"

@implementation TextViewController

- (void)loadView{
   
	CGFloat height = 288;
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WTEXTVC, height)];
    
    self.view.backgroundColor = [UIColor blackColor];
    
	doneBB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toolbarButtonClicked:)];
	cancelBB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(toolbarButtonClicked:)];
	
	
	
	self.navigationItem.rightBarButtonItem = doneBB;
    self.navigationItem.leftBarButtonItem = cancelBB;
    
	self.title = @"Add Text";
	
    displayedFontSize = isPad?30:20;
    
    
	CGFloat hTextView = isPad?self.view.height:125;
    CGFloat yOrigin = (isPhone&&isIOS7)?32:0;
    
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

- (void)viewWillAppear:(BOOL)animated{
    
	
	[super viewWillAppear:animated];
    
    [tv becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    
	[super viewDidAppear:animated];
    
    //	[tv becomeFirstResponder];
    settingVC.bgAlpha = bgAlpha;
    tv.contentOffset = CGPointZero;
    
}

#pragma mark - IBOutlet
- (IBAction)toolbarButtonClicked:(id)sender{
	
	if(sender == cancelBB){
		[self cancel];
	}
	else if(sender == doneBB){
		[self done];
	}
    
}


#pragma mark -

- (void)cancel{
    
    [_delegate textVCDidCancel:self];
}


- (void)done{
    
}

#pragma mark - Function
- (void)changeTextColor:(UIColor *)color {
    
    textColor = color;
    tv.textColor = color;
    
}

- (void)changeBGColor:(UIColor *)color {
    //    settingVC.bgColor = color;
    //    tv.backgroundColor = [color colorWithAlpha:settingVC.bgalpha];
    
    
    bgColor = color;
    tv.backgroundColor = [color colorWithAlpha:bgAlpha];
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
    textAlignment = tv.textAlignment;
}

- (void)changeBGAlpha:(float)newValue {
    //    tv.backgroundColor = [settingVC.bgColor colorWithAlpha:newValue];
    bgAlpha = newValue;
    tv.backgroundColor = [bgColor colorWithAlpha:newValue];
    
}

@end
