//
//  EditSideBGViewController.m
//  InstaMagazine
//
//  Created by AppDevelopper on 18.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "EditSideBGViewController.h"

#define kTagChristmasCell 333

@implementation EditSideBGViewController

@synthesize sidebar;

- (NSArray*)createPageBGImageNames{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Material" ofType:@"plist"];
    NSDictionary *materialDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
   NSArray* pageBGNames = [materialDict objectForKey:@"PageBGs"];
   NSArray* page_ChrismasImageNames = materialDict[@"PageBG_Christmas"];

    
    NSMutableArray *imgNames = [NSMutableArray array];
    [imgNames addObjectsFromArray:pageBGNames];
	[imgNames addObjectsFromArray:page_ChrismasImageNames];

    return imgNames;
}

- (void)loadView{
    [super loadView];
	
	self.title = @"Backgrounds";
		
	w = kwSidebar;
	h = kSideBarContentHeight;
	self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
	self.view.backgroundColor = kColorDarkPattern;
	
	/**
	 
	 margin 是最宽边的5%
	 
	 */

	thumbVs = [NSMutableArray array];
	numOfColumn = 2;
	thumbSize = isPad?CGSizeMake(114, 77):CGSizeMake(75, 50);
	margin = roundf((w-numOfColumn*thumbSize.width)/(numOfColumn+1));  //5,3
	

	tv = [[UITableView alloc]initWithFrame:self.view.bounds];
	tv.dataSource = self;
	tv.delegate = self;
	tv.separatorStyle = UITableViewCellSeparatorStyleNone;
	tv.backgroundColor = [UIColor clearColor];
    tv.autoresizingMask = kAutoResize;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"blackButtonBG.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:8 topCapHeight:0];
	startSlideB = [UIButton buttonWithFrame:CGRectMake(10, 10, tv.width-20, isPad?40:30) title:@"Use My Photo" image:nil target:self action:@selector(buttonClicked:)];
	[startSlideB setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[startSlideB.titleLabel setFont:[UIFont boldSystemFontOfSize:isPad?26:13]];

	[self.view addSubview:tv];
	
    bgImgNames = [self createPageBGImageNames];
}





#pragma mark -
#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	int num = 1;

	if (section == 0) {
		num = ceil((float)[bgImgNames count]/numOfColumn);

	}

	else if(section == 1){
		num = 1;
	}
	return num;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat hCell;
		
	if (indexPath.section == 0 ) { // bg

		hCell = thumbSize.height+margin;
	}

	else{ // photo album button
		hCell = isPad?180:80;
	}
	return hCell;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier1 = @"Cell1";

	UITableViewCell *cell;
	
	int section = indexPath.section;
	if (section == 0) {
		
		///  背景图片
		cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
		[thumbVs removeAllObjects];
		if (cell == nil) {
			cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            for (int i = 0; i<numOfColumn; i++) {
				
				UIImageView *v = [[UIImageView alloc]initWithFrame:CGRectMake((thumbSize.width+margin)*i+margin,margin, thumbSize.width, thumbSize.height)];
				v.userInteractionEnabled = YES;
				v.contentMode = UIViewContentModeScaleAspectFit;
				[v addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];

				[thumbVs addObject:v];
				[cell.contentView addSubview:v];
//				cell.contentView.backgroundColor = [UIColor redColor];
            }
		}
		else{
			
			[thumbVs addObjectsFromArray:cell.contentView.subviews];
			
		}
		
		for (int i = 0; i<2; i++) {
			int index = indexPath.row*2+i;
			
			UIImageView *imgV = thumbVs[i];
			
			if (index<[bgImgNames count]) {

				NSString *imgName = bgImgNames[index];
				UIImage *image = [UIImage imageWithSystemName:imgName];
				UIImage *thumImage = [image imageByScalingAndCroppingForSize:imgV.bounds.size];
				imgV.image = thumImage;
				imgV.tag = index+1;
			}
			else{
				// 防止最后一行多出的thumb被点击
				imgV.tag = 0;
			}
			
		}
		
	}
	else if(section == 1){ // section 2

		/// 使用自己图片
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
		[cell.contentView addSubview:startSlideB];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundView=[[UIView alloc] initWithFrame:cell.bounds];
	}

	
	return cell;

}



#pragma mark - ImagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	
	NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];

	[[NSNotificationCenter defaultCenter]postNotificationName:kNotificationChangeMomentBGImage object:url];
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	
	
	[picker.view slideOut];
	
}

#pragma mark - IBAction

- (void)handleTap:(UITapGestureRecognizer*)tap{
	
	int index = [[tap view]tag]-1;
	
	NSString *imgName = bgImgNames[index];
	
	[[NSNotificationCenter defaultCenter]postNotificationName:kNotificationChangeMomentBGImage object:imgName];
}



- (IBAction)buttonClicked:(id)sender{
	
	[self openPhotoAlbum];
}

#pragma mark -


- (void)openPhotoAlbum{
	L();
	
	UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
	if (isPad) {
		imgPicker.view.frame = CGRectMake(0, 0, 320, 500);
	}
	else{
		imgPicker.view.frame = self.navigationController.view.bounds;

	}
	imgPicker.delegate = self;
	imgPicker.allowsEditing = NO;
	
	if (isPad) {
//		[[ViewController sharedInstance]popViewController:imgPicker fromRect:self.view.frame];
//        pop = [[UIPopoverController alloc] init]
	}
	else
		[imgPicker.view slideInSuperview:self.navigationController.view];


}

@end
