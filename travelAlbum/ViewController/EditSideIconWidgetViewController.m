//
//  EditSideIconWidgetViewController.m
//  InstaMagazine
//
//  Created by AppDevelopper on 22.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "EditSideIconWidgetViewController.h"
#import "ImageModelView.h"
#import <QuartzCore/QuartzCore.h>

#define kTagChristmasCell 333

@implementation EditSideIconWidgetViewController

@synthesize sidebar;

- (NSMutableArray*)createStickers{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Material" ofType:@"plist"];
    NSDictionary *materialDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *iconWidgetNames = materialDict[@"IconWidgets"];
    NSMutableArray* allStickers = [NSMutableArray array];
    for (int i = 0; i< [iconWidgetNames count]; i++) {
        Sticker *sticker = [[Sticker alloc]initWithDictionary:iconWidgetNames[i]];
        [allStickers addObject:sticker];
    }
    
    return allStickers;
}

- (void)loadView{

	self.title = @"Stickers";
	
	stickerThumbs = [NSMutableArray array];
	availableStickers = [self createStickers];

	numOfColumn = isPad?3:3;
	thumbSize = isPad?CGSizeMake(72, 72):CGSizeMake(48, 48);
		
	
	w = kwSidebar;
	h = kSideBarContentHeight;
	self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];

	self.view.backgroundColor = kColorDarkPattern;

	tv = [[UITableView alloc]initWithFrame:CGRectMake(5, 10, w-10, h-10) style:UITableViewStylePlain];
	tv.dataSource = self;
	tv.delegate = self;
	tv.separatorStyle = UITableViewCellSeparatorStyleNone;
	tv.backgroundColor = [UIColor clearColor];
	[self.view addSubview:tv];
	
	margin = round((tv.width - numOfColumn * thumbSize.width)/(numOfColumn + 1));

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
		num = ceil((float)[availableStickers count]/numOfColumn);
	}
	else if(section == 1){
		num = 1;
	
	}

	return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat hCell = 40;
	
	if (indexPath.section == 0) { // bg
		hCell = thumbSize.height+margin;
	}
    else if(indexPath.section == 1){ //iap icon
        hCell = isPad?80:40;
    }
	
	return hCell;
}
//


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier1 = @"Cell1";
//	static NSString *CellIdentifier2 = @"Cell2";

	UITableViewCell *cell;
	
	int section = indexPath.section;
	if (section == 0) {
		
		cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
		[stickerThumbs removeAllObjects];
		if (cell == nil) {
			cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            for (int i = 0; i<numOfColumn; i++) {
				
				UIImageView *v = [[UIImageView alloc]initWithFrame:CGRectMake(margin+(thumbSize.width+margin)*i, margin, thumbSize.width, thumbSize.height)];
				v.userInteractionEnabled = YES;
				v.contentMode = UIViewContentModeScaleAspectFit;
				[v addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
				[stickerThumbs addObject:v];
				[cell.contentView addSubview:v];
            }
		}
		else{
			
			[stickerThumbs addObjectsFromArray:cell.contentView.subviews];
			
		}
		
		for (int i = 0; i<numOfColumn; i++) {
			int index = indexPath.row*numOfColumn+i;
			
			UIImageView *imgV = stickerThumbs[i];
			
			if (index<[availableStickers count]) {
				
				Sticker *sticker = availableStickers[index];
				UIImage *stickerImage =  [UIImage imageWithSystemName:sticker.imgName];

				imgV.image = [stickerImage imageByScaleingWithMaxLength:thumbSize.width];

				
				imgV.tag = index+1;

			}
			else{
				// 防止最后一行多出的thumb被点击
				imgV.tag = 0;
			}
			
		}
		
	}

	
	return cell;
	
}


#pragma mark - IBAction

//
- (void)handleTap:(UITapGestureRecognizer*)tap{
	
	
	int index = [[tap view]tag]-1;
	
	Sticker *sticker = availableStickers[index];

	ImageModelView *v = [[ImageModelView alloc]initWithImageName:sticker.imgName];
	v.layer.borderWidth = 0;
	
	
	[[NSNotificationCenter defaultCenter]postNotificationName:kNotificationAddWidget object:v];
    
    [[AlbumManager sharedInstance]setCurrentAlbumStatus:AlbumStatusChanged];
}


@end
