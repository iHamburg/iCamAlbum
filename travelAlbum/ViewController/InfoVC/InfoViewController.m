//
//  Info2ViewController.m
//  InstaMagazine
//
//  Created by AppDevelopper on 13.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "InfoViewController.h"
#import "Utilities.h"
#import "MoreApp.h"
#import "ExportController.h"
#import <QuartzCore/QuartzCore.h>
#import "FacebookManager.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)loadView{

		
	self.view = [[UIView alloc] initWithFrame:_r];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG_pattern_info.png"]];
//	width = self.view.width;
//	height = self.view.height;
	
	// w,h: 100/42, 有margin
	float faktor = kUniversalFaktor;
	CGFloat xBMargin = isPad?60:35;
	CGFloat yB = isPad?50:5;
	CGFloat wButton = isPad?80:40;
	CGFloat hButton = isPad?80:40;
	CGFloat yButtonsMargin = isPad?20:5;
	CGFloat hLabel = 30*faktor;
	
    
    backB = [UIButton buttonWithFrame:CGRectMake(3, 3, isPad?60:25, isPad?60:25) title:nil imageName:@"icon_back.png" target:self action:@selector(back)];
    
	
	instructionB = [UIButton buttonWithFrame:CGRectMake(xBMargin, yB, wButton, hButton) title:nil imageName:@"Info_Instruction.png" target:self action:@selector(toInstruction)];
	UILabel *instructionL = [[UILabel alloc]initWithFrame:CGRectMake(xBMargin-20, CGRectGetMaxY(instructionB.frame), wButton+40, hLabel)];
	instructionL.text = @"Instruction";
	
	aboutB = [UIButton buttonWithFrame:CGRectMake(xBMargin, CGRectGetMaxY(instructionL.frame)+yButtonsMargin, wButton, hButton) title:nil imageName:@"Info_Xapp.png" target:self action:@selector(aboutus)];
	UILabel *aboutL = [[UILabel alloc]initWithFrame:CGRectMake(xBMargin-20, CGRectGetMaxY(aboutB.frame), wButton+40, hLabel)];
	aboutL.text = @"About Us";
	recommendB = [UIButton buttonWithFrame:CGRectMake(xBMargin, CGRectGetMaxY(aboutL.frame)+ yButtonsMargin, wButton, wButton*0.66) title:nil imageName:@"Info_Email.png" target:self action:@selector(email)];
	UILabel *recommendL = [[UILabel alloc]initWithFrame:CGRectMake(xBMargin-20, CGRectGetMaxY(recommendB.frame), wButton+40, hLabel)];
	recommendL.text = @"Recommend";
	supportB = [UIButton buttonWithFrame:CGRectMake(xBMargin, CGRectGetMaxY(recommendL.frame)+ yButtonsMargin, wButton, hButton) title:nil imageName:@"Info_Support.png" target:self action:@selector(supportEmail)];
	UILabel *supportL = [[UILabel alloc]initWithFrame:CGRectMake(xBMargin-20, CGRectGetMaxY(supportB.frame), wButton+40, hLabel)];
	supportL.text = @"Support";
	facebookB = [UIButton buttonWithFrame:CGRectMake(xBMargin, CGRectGetMaxY(supportL.frame)+ yButtonsMargin, wButton, hButton) title:nil imageName:@"Info_facebook3.png" target:self action:@selector(facebook)];
	twitterB = [UIButton buttonWithFrame:CGRectMake(xBMargin, CGRectGetMaxY(facebookB.frame)+ yButtonsMargin + (isPad?4:2), wButton, hButton) title:nil imageName:@"Info_twitter3.png" target:self action:@selector(tweetus)];
	
	
	NSArray *buttons = @[aboutB,recommendB,supportB,facebookB,twitterB,instructionB];
	for (UIButton *b in buttons) {
		b.layer.shadowColor = [UIColor colorWithWhite:0.4 alpha:0.8].CGColor;
		b.layer.shadowOpacity = 1;
		b.layer.shadowOffset = isPad?CGSizeMake(2, 2):CGSizeMake(1, 1);
		b.layer.shadowRadius = 1;

	}
	
	NSArray *labels = @[instructionL,aboutL,recommendL,supportL];
	for (UILabel *l in labels) {
		
		l.textAlignment = NSTextAlignmentCenter;
		l.backgroundColor = [UIColor clearColor];
		l.textColor = [UIColor colorWithRed:0 green:103.0/255 blue:132.0/255 alpha:1];
		l.font = [UIFont fontWithName:kFontName size:isPad?20:10];
//		l.shadowColor = [UIColor colorWithWhite:0.6 alpha:0.8];
//		l.shadowOffset = CGSizeMake(0, isPad?2:1);
		[self.view addSubview:l];
		
	}
	
	[self.view addSubview:instructionB];
	[self.view addSubview:twitterB];
	[self.view addSubview:facebookB];
	[self.view addSubview:supportB];
	[self.view addSubview:recommendB];
	[self.view addSubview:aboutB];
	
	
	// binder right + More Apps
	
	binder = [[UIImageView alloc]initWithFrame:CGRectMake(0.18* _w, 0, isPad?72:30, _h)];
	binder.image = [UIImage imageWithContentsOfFileUniversal:@"Info_binder.png"];
	
	NSArray *moreAppNames;
	if (isPad) {
		moreAppNames = @[@"myecard",@"tinykitchen",@"nsc"];
	}
	else{
		moreAppNames = @[@"myecard",@"instahat",@"tinykitchen",@"nsc"];
	}

	NSString *moreAppsPlistPath = [[NSBundle mainBundle] pathForResource:@"MoreApps.plist" ofType:nil];
	NSDictionary *moreAppsDict = [NSDictionary dictionaryWithContentsOfFile:moreAppsPlistPath];
	moreApps = [NSMutableArray array];
	for (NSString *name in moreAppNames) {
		MoreApp *app = [[MoreApp alloc]initWithName:name dictionary:moreAppsDict[name]];
		[moreApps addObject:app];
	}

	ribbon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25*faktor, 25*faktor)];
	ribbon.image = [UIImage imageWithContentsOfFileUniversal:@"Info_selected.png"];

	
	scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.28*_w, (isPad?0.05:0.05)* _h, 0.67* _w, 0.2* _h)];
	scrollView.clipsToBounds = YES;
	scrollView.showsHorizontalScrollIndicator = NO;
	
	CGFloat sVMargin = 0.05*scrollView.height;
	CGFloat sButtonWidth = 0.8*scrollView.height;
	CGFloat sHorizontMargin = (scrollView.width-3*sButtonWidth)/5;
	for (int i = 0; i<[moreApps count]; i++) {

		UIButton *b = [UIButton buttonWithFrame:CGRectMake(20+(sHorizontMargin+sButtonWidth)*i, sVMargin, sButtonWidth, sButtonWidth) title:nil image:nil target:self action:@selector(buttonClicked:)];
		[b setImage:[UIImage imageWithContentsOfFileUniversal:[moreApps[i] imgName]] forState:UIControlStateNormal];
		b.tag = i+1;
		b.layer.shadowColor = [UIColor colorWithWhite:0.2 alpha:0.8].CGColor;
		b.layer.shadowOpacity = 1;
		b.layer.shadowOffset = isPad?CGSizeMake(3, 3):CGSizeMake(1, 1);
		b.layer.shadowRadius = 1;
		
		[scrollView addSubview:b];
		[scrollView setContentSize:CGSizeMake(CGRectGetMaxX(b.frame)+200, 0)];
		
		if (i == 0) {
			firstAppB = b;
		}
	}

	//App Description TextView
	otherAppL = [[UILabel alloc]initWithFrame:CGRectMake(0.28*_w, CGRectGetMaxY(scrollView.frame)+30*faktor, 0.67*_w, 0.1*_h)];
	otherAppL.textAlignment = UITextAlignmentCenter;
	otherAppL.backgroundColor = [UIColor colorWithHEX:@"6c675f"];
	otherAppL.font = [UIFont fontWithName:kFontName size:isPad?50:21];
	otherAppL.textColor = [UIColor whiteColor];
	otherAppL.userInteractionEnabled = YES;
	otherAppL.shadowColor = [UIColor colorWithWhite:0 alpha:0.8];
	otherAppL.shadowOffset = CGSizeMake(0, isPad?4:2);

	
	CGFloat dBWidth = isPad?150:75;
	CGFloat dBHeight = isPad?50:25;
	CGFloat yDownloadBMargin = 10*faktor;
	downloadB = [UIButton buttonWithFrame:CGRectMake(CGRectGetMaxX(otherAppL.bounds)-dBWidth-5, yDownloadBMargin, dBWidth, dBHeight) title:nil image:nil target:self action:@selector(appstore)];
	[downloadB setImage:[UIImage imageWithContentsOfFileUniversal:@"Icon_AppstoreDownload.png"] forState:UIControlStateNormal];
	downloadB.center = CGPointMake(CGRectGetMaxX(otherAppL.bounds)-dBWidth/2-5 , otherAppL.height/2);
	downloadB.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.8].CGColor;
	downloadB.layer.shadowOpacity = 1;
	downloadB.layer.shadowOffset = isPad?CGSizeMake(2, 2):CGSizeMake(1, 1);
	downloadB.layer.cornerRadius = isPad?5:3;
	downloadB.layer.borderWidth = 2;
	downloadB.layer.borderColor = [UIColor whiteColor].CGColor;
	
	[otherAppL addSubview:downloadB];
	

	textV = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMinX(otherAppL.frame), CGRectGetMaxY(otherAppL.frame), otherAppL.width, 0.54*_h)];
	textV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
	textV.textColor = [UIColor colorWithHEX:@"4d4e53"];
	textV.font = [UIFont boldSystemFontOfSize:isPad?22:11];
	textV.editable = NO;
	
	
	
	[self.view addSubview:textV];
	[self.view addSubview:otherAppL];
	[self.view addSubview:scrollView];
	[self.view addSubview:binder];
	[self.view addSubview:backB];
	
	[self buttonClicked:firstAppB];
}



- (NSUInteger)supportedInterfaceOrientations{
    
	return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}


- (void)dealloc{
    L();
//    NSLog(@"info # %@",self);
//    [self.view moveOrigin:<#(CGPoint)#>]
}

#pragma mark - IBAction
- (IBAction)buttonClicked:(id)sender{
	L();
	UIButton *b = sender;
	selectedIndex = [sender tag]-1;
	
	MoreApp *app = moreApps[selectedIndex];

	ribbon.frame = CGRectMake(b.center.x-ribbon.width/2, CGRectGetMaxY(b.frame)-(isPad?5:1), ribbon.width, ribbon.height);

	[scrollView insertSubview:ribbon belowSubview:b];
	
	textV.text = app.description;
	otherAppL.text = app.title;
	[textV setContentOffset:CGPointMake(0, 0)];
}

#pragma mark -

- (void)back{
	NSLog(@"info # %@",self);
    [_delegate infoVCWillClose:self];
}

- (void)toInstruction{
//
//	if(!instructionVC){
		instructionVC = [[VerticalInstructionViewController alloc]init];
		instructionVC.view.frame = self.view.bounds;
		instructionVC.delegate = self;
//	}
	
	[self.view addSubview:instructionVC.view];
}

- (void)rateUs{
    [[ExportController sharedInstance]toRate];
}

- (void)instructionVCWillDismiss:(InstructionViewController *)vc{
	[vc.view removeFromSuperview];
}

- (void)aboutus{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.xappsoft.de/index.php?lang=en"]];
}
- (void)tweetus{
	

	[[ExportController sharedInstance]sendTweetWithText:STwitter image:nil];
}
- (void)facebook{
	

	[[FacebookManager sharedInstance]feed];
}
- (void)email{
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  SRecommendEmailTitle, @"subject",
						  SRecommendEmailBody,@"emailBody",
						  nil];
	
	[[ExportController sharedInstance] sendEmail:dict];
	
}
- (void)supportEmail{
	
	
	NSDictionary *dict2 = @{
	@"subject": SSupportEmailTitle,
	@"toRecipients": @[@"support@xappsoft.de"]
	};
	
    
	[[ExportController sharedInstance] sendEmail:dict2];
}

- (void)appstore{
	MoreApp *app = moreApps[selectedIndex];
	NSString *appid = app.fAppid;
	
	NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/de/app/id%@&mt=8",appid];
	NSURL *url = [NSURL URLWithString: [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF16StringEncoding]];
    
//    NSURL *url =  [NSURL URLWithString:@"https://itunes.apple.com/de/app/id577927911&mt=8"];
	[[UIApplication sharedApplication] openURL:url];
	
}

- (void)selectApp:(MoreApp*)app{
    
    NSString *appid = isPaid()?app.pAppid:app.fAppid;
    
    [[ExportController sharedInstance]linkToAppStoreWithID:appid];
}
@end
