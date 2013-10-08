//
//  ColorPlatteView.m
//  XappCard
//
//  Created by  on 06.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "MyColorPlatteView.h"
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"


@interface MyColorPlatteView ()


- (void)initSubviews;

@end

@implementation MyColorPlatteView

@synthesize delegate, selectedIndex;


NSString* myColorPalette[8][4] = {
	
	@"ffffff",@"d1d1d1",@"9b9ba1",@"434343", //black and white
	@"e33135",@"8f3530",@"6b5f53",@"707f44", //green
	@"c3a982",@"684934",@"6B9A32",@"b4dbcb", //red
	@"1b3e5d",@"80b4c1",@"bbd1d6",@"c5cedd", //blue
	@"babaad",@"a28eb4",@"5a4068",@"605861", //yellow
	@"e6d6bb",@"ddb676",@"af7f49",@"f6ce70", //other
	@"eb7842",@"fdbfa8",@"564d83",@"9b6950", //yellow
	@"e4f2f2",@"90aeb8",@"b38f77",@"dbcdbd", //other
	
};


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

		[self initSubviews];
	}
    return self;
}

- (void)awakeFromNib{

	[self initSubviews];
}

// 6x4 填满整个屏幕

- (void)initSubviews{
	
	w = self.width;   //240
	h = self.height;
	
	thumbImgVs = [NSMutableArray array];
	thumbSize = isPad?CGSizeMake(54, 54):CGSizeMake(48, 48);
	numOfThumbsInRow = 4;
	margin = round((w-numOfThumbsInRow*thumbSize.width)/(numOfThumbsInRow+1));
	selectedIndex = -1;
	
	self.backgroundColor = kColorDarkPattern;
	
	selected = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, thumbSize.width * (1.1), thumbSize.height * (1.1))];
	selected.backgroundColor = [UIColor whiteColor];
	selected.layer.cornerRadius = selected.width/2;

	
	tv = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
	tv.dataSource = self;
	tv.delegate = self;
	tv.backgroundColor = [UIColor clearColor];
	tv.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[self addSubview:tv];
}


#pragma mark -
#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat hCell = 44;
	
	if (indexPath.section == 0) { // bg
		hCell = thumbSize.height+margin;
	}
   
	
	return hCell;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier1 = @"Cell1";

	UITableViewCell *cell;
	
	int section = indexPath.section;
	int row = indexPath.row;
	if (section == 0) {
		
		cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
		[thumbImgVs removeAllObjects];
		if (cell == nil) {
			cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            for (int i = 0; i<numOfThumbsInRow; i++) {
				
				UIImageView *v = [[UIImageView alloc]initWithFrame:CGRectMake(margin+(thumbSize.width+margin)*i, margin, thumbSize.width, thumbSize.height)];
				v.userInteractionEnabled = YES;
			
				[v addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
				v.layer.cornerRadius = thumbSize.width/2;
				v.layer.masksToBounds = YES;
				[thumbImgVs addObject:v];
				[cell.contentView addSubview:v];
            }
		}
		else{
			
			[thumbImgVs addObjectsFromArray:cell.contentView.subviews];
			
		}
		
		for (int i = 0; i<numOfThumbsInRow; i++) {

			int index = indexPath.row*numOfThumbsInRow+i;
			UIImageView *v = thumbImgVs[i];
			
			NSString *colorStr = myColorPalette[row][i];
			v.backgroundColor = [UIColor colorWithHEX:colorStr];
			v.tag = index;
				
			if (index == selectedIndex) {
				selected.center = v.center;
				
				//defensive setting： selected的颜色会自己变化，所以强制设为white
				selected.backgroundColor = [UIColor whiteColor];
				
				[v.superview insertSubview:selected belowSubview:v];
			}
			else{
				if ([cell.contentView.subviews containsObject:selected]) {
					[selected removeFromSuperview];
				}
			}
		}
		
	}

	
	return cell;
	
}


- (void)handleTap:(UITapGestureRecognizer*)gesture{
	L();
	UIView *v = gesture.view;
	selected.center = v.center;

	//defensive setting： selected的颜色会自己变化，所以强制设为white
	selected.backgroundColor = [UIColor whiteColor];

	[v.superview insertSubview:selected belowSubview:v];
	
	// 用来消除cell的复用的影响的
	selectedIndex = v.tag;
	UIColor *color = v.backgroundColor;
	
	[delegate colorPlatte:self didTapColor:color];
}


@end
