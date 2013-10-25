//
//  PhotoCropViewController.m
//  InstaMagazine
//
//  Created by XC  on 11/7/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "PhotoCropViewController.h"
#import "PathImageView.h"
#import "ImageModelView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PhotoCropViewController

@synthesize piece,vc;

- (void)setPiece:(ImageModelView*)_piece{
	
	croppedFlag = NO;
	[pathV removeFromSuperview];
    
	[_piece resetAnchorPoint];

	originalTransform = _piece.transform; //cancel 时复原
	originalBounds = _piece.bounds;  // cancel 时复原
	originalWBorder = _piece.layer.borderWidth;  // cancel 时复原
	
	piece = _piece;
	
	///转成正面,放到正中
    piece.transform = CGAffineTransformIdentity;
	piece.center = CGPointMake(pageContainer.bounds.size.width/2, pageContainer.bounds.size.height/2);
	piece.layer.borderWidth = 0;
	
	originalCroppedImage = nil;
	originalImage = piece.image;
	identityFrame = piece.frame;
		
	// 把piece的位置放到pageContainer中心

	cancelB.center = CGPointMake(CGRectGetMinX(piece.frame), MAX(CGRectGetMinY(piece.frame),cancelB.height/2));
	doneB.center = CGPointMake(CGRectGetMaxX(piece.frame), MAX(CGRectGetMinY(piece.frame),cancelB.height/2));

	pathV= [[PathImageView alloc]initWithFrame:piece.frame];
    pathV.delegate = self;
	
	bgImgV.frame = pathV.frame;
	bgImgV.image = originalImage;

	NSLog(@"piece to crop # %@",piece);
	
	[pageContainer addSubview:bgImgV];
	[pageContainer addSubview:piece];
	[pageContainer addSubview:pathV];
	[pageContainer addSubview:cancelB];
	[pageContainer addSubview:doneB];
	

}

- (void)loadView{
//    w = _w;
//    h = _h;
	self.view = [[UIView alloc]initWithFrame:_r];
	self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
  
	CGFloat wCancelB = isPad?40:30;
	cancelB = [UIButton buttonWithFrame:CGRectMake(0, 0, wCancelB, wCancelB) title:nil bgImageName:@"Icon_PhotoCancel.png" target:self action:@selector(buttonClicked:)];
	doneB = [UIButton buttonWithFrame:CGRectMake(0, 0, wCancelB, wCancelB) title:nil bgImageName:@"Icon_PhotoDone.png" target:self action:@selector(buttonClicked:)];
    [cancelB setImage:[UIImage imageWithSystemName:@"Icon_PhotoCancel.png"] forState:UIControlStateNormal];
  
	[doneB setImage:[UIImage imageWithSystemName:@"Icon_PhotoDone.png"] forState:UIControlStateNormal];
    
	pageContainer = [[UIView alloc]initWithFrame:self.view.bounds];
    
	bgImgV = [[UIImageView alloc]init];
	bgImgV.alpha = 0.4;


    [self.view addSubview:pageContainer];


}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewWillAppear:(BOOL)animated{
    L();
    [super viewWillAppear:animated];
    
    [self layoutADBanner:[ICAAdView sharedInstance]];
}

#pragma mark - PathImageView
- (void)pathImageViewDidBeginDraw:(PathImageView *)pathV{
	
	///retry
	
	piece.frame = identityFrame;
	piece.image = originalImage;

}

- (void)pathImageView:(PathImageView *)pathV didFinishDrawWithPath:(UIBezierPath *)maskPath{

	UIImage *croppedImage = [piece.image imageByCroppedPath:maskPath];

    
    CGRect pathRect = maskPath.bounds;
    CGRect imgRect = CGRectMake(0, 0, piece.image.size.width, piece.image.size.height);
    CGRect newPathRect = CGRectIntersection(pathRect, imgRect);
    
		
	// frame 100,100,100,100 ->120,120,50,50 (改变了原点和size)
    piece.frame = CGRectMake(piece.frame.origin.x+newPathRect.origin.x, piece.frame.origin.y+newPathRect.origin.y, newPathRect.size.width, newPathRect.size.height);
    piece.image = croppedImage;
    piece.layer.borderWidth = 0;
	
	croppedFlag = YES;

}

#pragma mark - IBAction
- (void)buttonClicked:(id)sender{
    if (sender == cancelB) {
        
        [self cancel];
        
    }
    else if(sender == doneB){
        [self done];
    }

}

#pragma mark - Adview
- (void)layoutADBanner:(AdView *)banner{
    
    if (!banner.isAdDisplaying) {
        [banner setOrigin:CGPointMake(0, _h)];
    }
	[UIView animateWithDuration:0.25 animations:^{
		
		if (banner.isAdDisplaying) { // 从不显示到显示banner
			
//			[svContainer setOrigin:CGPointMake(0, self.view.height - svContainer.height - banner.height)];
            
            //            NSLog(@"svContainer # %@",svContainer);
            [banner setOrigin:CGPointMake(0, _h- banner.height)];
            
		}
		else{
			
//			[svContainer setOrigin:CGPointMake(0, self.view.height - svContainer.height)];
			[banner setOrigin:CGPointMake(0, _h)];
		}
		
    }];
    
    
    
}

#pragma mark -
- (void)cancel{

	piece.transform = originalTransform;
	piece.layer.borderWidth = originalWBorder;

	if (croppedFlag) {

		piece.bounds = originalBounds;
	}

	piece.image = originalImage;
	
	[vc closePhotoCrop:piece];
}

- (void)done{
    
	
	if (croppedFlag) {

		[piece.image saveWithName:[(ImageModelView*)piece imgName]];
		
	}
	   
	[vc closePhotoCrop:piece];
}



@end
