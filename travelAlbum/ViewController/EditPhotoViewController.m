//
//  EditPhotoViewController.m
//  MyPhotoAlbum
//
//  Created by  on 08.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "ImageModelView.h"
#import "PhotoEditRahmenView.h"
#import "PathImageView.h"
#import "Macros.h"

#define kFilterImageViewTag 9999
#define kFilterImageViewContainerViewTag 9998
#define kFilterCellHeight (isPad?72.0f:40.0f)
#define kBlueDotImageViewOffset (isPad?25.0f:9.0f)
#define kBlueDotAnimationTime 0.2f

@interface EditPhotoViewController ()

@end

@implementation EditPhotoViewController



@synthesize vc,hSvContainer;


// ipad: 1024x100,50x50

- (void)loadView{
    
    self.view = [[UIView alloc]initWithFrame:_r];
//    [super loadView];
    
	pieces = [NSMutableArray array];
	originalImages = [NSMutableArray array];
	originalBorderColors = [NSMutableArray array];
	originalBorderWidths = [NSMutableArray array];
	
    
  
    
    [self registerNotifications];
	
	
	pageContainer = [[UIView alloc]initWithFrame:self.view.bounds];

	
	hSvContainer = isPad?100:50;
	wLeft = isPad?120:80;
	CGFloat wRight = isPad?100:0;
	wScroll = _w - wLeft - wRight;
	CGFloat wCancelB = isPad?40:30;

	
	wFXBorder = 3;

	fxB = [UIButton buttonWithFrame:CGRectMake(0, 0, wLeft, hSvContainer/2) title:nil bgImageName:nil target:self action:@selector(buttonClicked:)];
	frameB = [UIButton buttonWithFrame:CGRectMake(0, CGRectGetMaxY(fxB.frame), wLeft, hSvContainer/2) title:nil bgImageName:nil target:self action:@selector(buttonClicked:)];


    cancelB = [UIButton buttonWithFrame:CGRectMake(0, 0, wCancelB, wCancelB) title:nil imageName:@"Icon_PhotoCancel.png" target:self action:@selector(buttonClicked:)];
    [cancelB setImage:[UIImage imageWithSystemName:@"Icon_PhotoCancel.png"] forState:UIControlStateNormal];
    
	doneB = [UIButton buttonWithFrame:CGRectMake(0,0, wCancelB, wCancelB) title:nil imageName:@"Icon_PhotoDone.png" target:self action:@selector(buttonClicked:)];
	[doneB setImage:[UIImage imageWithSystemName:@"Icon_PhotoDone.png"] forState:UIControlStateNormal];
    
    svContainer = [[UIView alloc]initWithFrame:CGRectMake(0, _h - hSvContainer, _w, hSvContainer)];
    svContainer.backgroundColor = [UIColor colorWithRed:67.0/255 green:67.0/255 blue:67.0/255 alpha:1];
	svContainer.clipsToBounds = YES;
	[svContainer addSubview:fxB];
	[svContainer addSubview:frameB];

	

	
	if (isPad) {
		cancelB.center = CGPointMake(_w- (wRight/2), 0.25*hSvContainer);
		doneB.center = CGPointMake(_w- (wRight/2),0.75*hSvContainer);
		[svContainer addSubview:cancelB];
		[svContainer addSubview:doneB];
	}
	else{
        
        /// iphone 的size太小，所以放到屏幕上角
        
		[cancelB setOrigin:CGPointMake(5, 5)];
		[doneB setOrigin:CGPointMake(pageContainer.width-wCancelB - 5, 5)];
		[pageContainer addSubview:cancelB];
		[pageContainer addSubview:doneB];

//        cancelB.center = CGPointMake(_w- (wRight/2)-10, 0.25*hSvContainer);
//		doneB.center = CGPointMake(_w - (wRight/2)-10,0.75*hSvContainer);
//        [svContainer addSubview:cancelB];
//		[svContainer addSubview:doneB];
	
    }
	[self.view addSubview:pageContainer];
    [self.view addSubview:svContainer];
    
	
}


- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
    [self layoutADBanner:[ICAAdView sharedInstance]];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	
}

- (void)viewDidAppear:(BOOL)animated{
    L();
    [super viewDidAppear:animated];
  
	// 每次打开PhotoEdit，之前的select都清空

    [self toFilterTable];
	[rahmenSV setup];

	
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Notification
- (void)registerNotifications{

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAdChanged:) name:NotificationAdChanged object:nil];
}

- (void)notifyAdChanged:(NSNotification*)notification{
     [self layoutADBanner:notification.object];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 18;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return kFilterCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//	int row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	UIImageView *filterImageView;
    UIView *filterImageViewContainerView;
    // Configure the cell...
	if (!cell) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];  cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
		cell.contentView.backgroundColor = [UIColor clearColor];
		
        filterImageView = [[UIImageView alloc] initWithFrame:isPad?CGRectMake(17.5, -7.5, 57, 72):CGRectMake(8, -4, 32, 40)];
        filterImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        filterImageView.tag = kFilterImageViewTag;
        
        filterImageViewContainerView = [[UIView alloc] initWithFrame:isPad?CGRectMake(0, 7, 100, 72):CGRectMake(0, 3, 50, 40)];
        filterImageViewContainerView.tag = kFilterImageViewContainerViewTag;
        [filterImageViewContainerView addSubview:filterImageView];
//        [filterImageViewContainerView setBackgroundColor:[UIColor redColor]];
		
        [cell.contentView addSubview:filterImageViewContainerView];

	}
 
	
    switch ([indexPath row]) {
        case 0: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNormal" ofType:@"png"]];
			
            break;
        }
        case 1: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileAmaro" ofType:@"png"]];
            
            break;
        }
        case 2: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileRise" ofType:@"png"]];
            
            break;
        }
        case 3: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileHudson" ofType:@"png"]];
            
            break;
        }
        case 4: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileXpro2" ofType:@"png"]];
            
            break;
        }
        case 5: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileSierra" ofType:@"png"]];
            
            break;
        }
        case 6: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileLomoFi" ofType:@"png"]];
            
            break;
        }
        case 7: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileEarlybird" ofType:@"png"]];
            
            break;
        }
        case 8: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileSutro" ofType:@"png"]];
            
            break;
        }
        case 9: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileToaster" ofType:@"png"]];
            
            break;
        }
        case 10: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileBrannan" ofType:@"png"]];
            
            break;
        }
        case 11: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileInkwell" ofType:@"png"]];
            
            break;
        }
        case 12: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileWalden" ofType:@"png"]];
            
            break;
        }
        case 13: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileHefe" ofType:@"png"]];
            
            break;
        }
        case 14: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileValencia" ofType:@"png"]];
            
            break;
        }
        case 15: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNashville" ofType:@"png"]];
            
            break;
        }
        case 16: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTile1977" ofType:@"png"]];
            
            break;
        }
        case 17: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileLordKelvin" ofType:@"png"]];
            break;
        }
            
        default: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNormal" ofType:@"png"]];
			
            break;
        }
	}


	
//	cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	int row = indexPath.row;

	CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
    CGRect tempRect = self.blueDotImageView.frame;
    tempRect.origin.y = cellRect.origin.y + kBlueDotImageViewOffset;
    
    [UIView animateWithDuration:kBlueDotAnimationTime animations:^() {
        self.blueDotImageView.frame = tempRect;
    }completion:^(BOOL finished){
        
    }];
	[self applyImageFilter:row];
	


	
}


#pragma mark - IBAction
- (void)buttonClicked:(id)sender{
    if (sender == cancelB) {
        [self cancel];
    }
    else if(sender == doneB){
        [self done];
    }
    else if(sender == fxB){
		
		[self toFilterTable];
    }

    else if(sender == frameB){
        [self toFrame];
    }
}
//
//- (void)handleTap:(UITapGestureRecognizer*)tap{
//	L();
//	
//	CGPoint point = [tap locationInView:pageContainer];
//	
//	PhotoWidget *newWidget = [vc firstWidgetInPoint:point];
//	
//	if (newWidget) {
//		
//		if ([pieces containsObject:newWidget]) {
//			[self deleteOldPiece:newWidget];
//		}
//		else{
//			[self addNewPiece:newWidget];
//		}
//		
//	}
//
//}


#pragma mark -

- (void)addNewPiece:(ImageModelView*)newPiece{
    
	[pieces addObject:newPiece];
	
	newPiece.alpha = 1;
	
	[originalImages addObject:[newPiece image]];
	[originalBorderColors addObject:[UIColor colorWithCGColor:newPiece.layer.borderColor]];
	[originalBorderWidths addObject:[NSNumber numberWithFloat:newPiece.layer.borderWidth]];
	
}
//- (void)deleteOldPiece:(ImageModelView*)oldPiece{
//	
//	oldPiece.alpha = 0.3;
//	
//	int index = [pieces indexOfObject:oldPiece];
//    [pieces removeObject:oldPiece];
//	[originalImages removeObjectAtIndex:index];
//	[originalBorderColors removeObjectAtIndex:index];
//	[originalBorderWidths removeObjectAtIndex:index];
//}

- (void)cancel{

    for (int i = 0; i< [pieces count]; i++) {
		ImageModelView *piece = pieces[i];
		UIImage *originalImage = originalImages[i];
		
		piece.image = originalImage;
		piece.layer.borderWidth = [originalBorderWidths[i] floatValue];
		UIColor *color = originalBorderColors[i];
		piece.layer.borderColor = color.CGColor;
	}

	
	[pieces removeAllObjects];
	[originalImages removeAllObjects];
	[originalBorderWidths removeAllObjects];
	[originalBorderColors removeAllObjects];
	
	[UIView animateWithDuration:0.4 animations:^{
		[svContainer moveOrigin:CGPointMake(0, hSvContainer)];
	} completion:^(BOOL finished) {
		[vc closePhotoEdit];
		
	}];

	
	
}
- (void)done{

	
	for (int i = 0; i< [pieces count]; i++) {
		ImageModelView *piece = pieces[i];
		UIImage *originalImage = originalImages[i];
		
		if (piece.image != originalImage) {

			[piece.image saveWithName:piece.imgName];

		}

	}
	
	
	[pieces removeAllObjects];
	[originalImages removeAllObjects];
	[originalBorderWidths removeAllObjects];
	[originalBorderColors removeAllObjects];

	[UIView animateWithDuration:0.4 animations:^{
		[svContainer moveOrigin:CGPointMake(0, hSvContainer)];
	} completion:^(BOOL finished) {
		[vc closePhotoEdit];
		
	}];
}



#pragma mark - Filters & Frames



- (void)toFilterTable{
	
	[fxB setImage:[UIImage imageNamed:@"effects_highlighted.png"] forState:UIControlStateNormal];
	
	[frameB setImage:[UIImage imageNamed:@"frames_normal.png"] forState:UIControlStateNormal];
	
	

	if (!filterTableView) {
		filterTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,  hSvContainer,wScroll) style:UITableViewStylePlain];
		filterTableView.center = CGPointMake(svContainer.width/2, svContainer.height/2);
		filterTableView.transform =  CGAffineTransformMakeRotation(-M_PI/2);
		filterTableView.dataSource = self;
		filterTableView.delegate = self;
		filterTableView.backgroundColor = [UIColor clearColor];
		filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		
		self.blueDotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-3, kBlueDotImageViewOffset + 4, 21, 11)];
		self.blueDotImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraSelectedFilter" ofType:@"png"]];
		self.blueDotImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
		[filterTableView addSubview:self.blueDotImageView];
		
		[svContainer addSubview:filterTableView];
	}
	
	
	
	UIView *outV = rahmenSV;
	UIView *inV = filterTableView;
	
	[inV setOrigin:CGPointMake(wLeft, hSvContainer)];
    [svContainer addSubview:inV];
	
	[UIView animateWithDuration:0.3 animations:^{
		[inV moveOrigin:CGPointMake(0, -hSvContainer)];
		[outV moveOrigin:CGPointMake(0, -hSvContainer)];
		
	} completion:^(BOOL finished) {
		[outV removeFromSuperview];
	}];

}

/*
 
 cropped 的editpiece不能加frame
 */

- (void)toFrame{


	[fxB setImage:[UIImage imageNamed:@"effects_normal.png"] forState:UIControlStateNormal];
	[frameB setImage:[UIImage imageNamed:@"frames_highlighted.png"] forState:UIControlStateNormal];

   
    if (!rahmenSV) {

        rahmenSV = [[PhotoEditRahmenView alloc]initWithFrame:CGRectMake(wLeft, 0, wScroll, hSvContainer)];
        rahmenSV.parent = self;
    }
	
	// 如果rahmenSV已经有了，就return
	if (rahmenSV.superview) {
		return;
	}
	
	
    [rahmenSV setup]; // remove selectedcheck
    
	UIView *outV = filterTableView;
	UIView *inV = rahmenSV;
	
	[inV setOrigin:CGPointMake(wLeft, hSvContainer)];
    [svContainer addSubview:inV];

	[UIView animateWithDuration:0.3 animations:^{
		[inV moveOrigin:CGPointMake(0, -hSvContainer)];
		[outV moveOrigin:CGPointMake(0, -hSvContainer)];
		
	} completion:^(BOOL finished) {
		[outV removeFromSuperview];
	}];
	
}

#pragma mark -


- (void)applyImageFilter:(IFFilterType)filterType{
	
	for (int i = 0; i<[pieces count]; i++) {
		ImageModelView *p = pieces[i];
		p.image = [[IFFilterManager sharedInstance] filteredImageWithRaw:originalImages[i] filterType:filterType];
	}

}


- (void)applyRahmenColor:(UIColor*)color{
    if (color) {
        //apply rahmen

		for (int i = 0; i<[pieces count]; i++) {
			ImageModelView *p = pieces[i];

			p.layer.borderColor = color.CGColor;
			p.layer.borderWidth = kWPhotoWidgetFrame;
		}
    }
    else{

		for (int i = 0; i<[pieces count]; i++) {
			ImageModelView *p = pieces[i];
			p.layer.borderWidth = 0;
		}
	
	}
}

#pragma mark - Adview

- (void)layoutADBanner:(AdView *)banner{
    
    if (!banner.isAdDisplaying) {
        [banner setOrigin:CGPointMake(0, _h)];
    }
	[UIView animateWithDuration:0.25 animations:^{
		
		if (banner.isAdDisplaying) { // 从不显示到显示banner
			
			[svContainer setOrigin:CGPointMake(0, self.view.height - svContainer.height - banner.height)];
	
//            NSLog(@"svContainer # %@",svContainer);
            [banner setOrigin:CGPointMake(0, _h- banner.height)];
            
		}
		else{
			
			[svContainer setOrigin:CGPointMake(0, self.view.height - svContainer.height)];
			[banner setOrigin:CGPointMake(0, _h)];
		}
		
    }];
    
    

}

#pragma mark -
- (void)test:(UIView*)v{
//	UIImage *img = [UIImage imageWithView:v];
//	
//	NSLog(@"img # %@",NSStringFromCGSize(img.size));
//	
//	UIImageView *imgV2 = [[UIImageView alloc]initWithImage:img];
//	imgV2.backgroundColor = [UIColor redColor];
//	[self.view addSubview:imgV2];
//
//	NSLog(@"before switch img to imgV");
//	UIImageView *imgV = [[UIImageView alloc]initWithImage:[[IFFilterManager sharedInstance]img]];
//	imgV.backgroundColor = [UIColor blueColor];
//	[self.view addSubview:imgV];
}
@end
