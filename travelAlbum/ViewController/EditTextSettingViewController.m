//
//  EditTextSettingViewController.m
//  Everalbum
//
//  Created by AppDevelopper on 03.01.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

/**
 
 text font  (String) ->
 text color (color), -> uiview of color
 
 bg color   (color)   -> uivie of wcolor
 bg alpha   (float): slide
 
 stroke     (uicolor) : switch
 
 textalignment (int)  3选一 segment
 */

#import "EditTextSettingViewController.h"
#import "FontScrollView.h"
#import <QuartzCore/QuartzCore.h>

@interface EditTextSettingViewController ()

@end

@implementation EditTextSettingViewController

@synthesize parent, textFontName,textColor,bgColor,textAlignment,bgalpha;
@synthesize bgAlphaSlider,strokeSwitch;

//@synthesize colorMode;

- (void)setLabelMV:(LabelModelView *)labelMV{
	_labelMV = labelMV;
	
	
	textColor = _labelMV.textColor;
	textAlignment = _labelMV.textAlignment;
	textFontName = _labelMV.fontName;
	bgColor = _labelMV.bgColor;
	bgalpha = _labelMV.bgAlpha;
	
	NSLog(@"bgalpha # %f",bgalpha);
	
	[tv reloadData];
}

- (void)loadView{

    /// ios7 不能stroke，所以就没有这个选项
    if (isIOS7) {
        tableHeaders = @[@"Text",@"Background",@""];
        tableKeys = @[@[@"Font",@"Color"],
                      @[@"Background",@"Transparency"],
                      @[@"Text alignment"]];
    }
    else{
        tableHeaders = @[@"Text",@"Background",@"",@""];
        tableKeys = @[@[@"Font",@"Color"],
                      @[@"Background",@"Transparency"],
                      @[@"Font Outline"],
                      @[@"Text alignment"]];
	    
    }
	
	

    CGFloat w = _w/2;
	CGFloat h;
    
    if (isIOS7) {
        h = 320;
    }
    else
        h = 288;
	
	self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    self.view.backgroundColor = [UIColor colorWithHEX:@"efeff4"];
	self.title = @"Text Options";
	
	//如果是pad，需要加上一个margin来offset，landscape pop hide navibar 的问题
	tv = [[UITableView alloc]initWithFrame:isPad?CGRectMake(0, 0, w, h+8):CGRectMake(50, 0, w-100, h) style:UITableViewStyleGrouped];
	tv.delegate = self;
	tv.dataSource = self;

	[self.view addSubview:tv];
	
	bgAlphaSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
	[bgAlphaSlider addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged];
	

	NSArray *imgNames = @[@"icon_alignLeft.png",@"icon_alignCenter.png",@"icon_alignRight.png"];
	
	NSMutableArray *imgs = [NSMutableArray array];
	for (NSString *imgName in imgNames) {
		UIImage *img = [UIImage imageWithContentsOfFileName:imgName];
		[imgs addObject:img];
		
	}
	textAlignSeg= [[UISegmentedControl alloc]initWithItems:imgs];
	textAlignSeg.frame = CGRectMake(0, 0, 150, 40);
	[textAlignSeg addTarget:parent action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];

	strokeSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)segmentValueChanged:(id)sender{
//    [parent segmentValueChanged:sender];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	
    return [tableHeaders count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return tableHeaders[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	return [tableKeys[section] count];
	
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	int row = indexPath.row;
	int section = indexPath.section;
	
	
	// 只会调用一次，所以不用复用cell！
	
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	/**
	 
	 text font  (String) ->
	 text color (color), -> uiview of color
	 
	 bg color   (color)   -> uivie of wcolor
	 bg alpha   (float): slide
	 
	 stroke     (uicolor) : switch
	 
	 textalignment (int)  3选一 segment
	 */
	UIView *v = [[UIView alloc]initWithFrame:CGRectMake(260, 4, 55, 36)];

	if (section == 0) {
		if (row == 0) {
			cell.detailTextLabel.text = textFontName;
		}
		else if(row == 1){

			v.backgroundColor = textColor;

			[cell.contentView addSubview:v];
			
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else if(section == 1){

		 if (row == 0) {
			v.backgroundColor = bgColor;
			[cell.contentView addSubview:v];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
		}
		else if(row == 1){

			bgAlphaSlider.value = bgalpha;
			cell.accessoryView = bgAlphaSlider;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
	}
	else if(section == 2){

        if (kVersion>=7.0) {
            textAlignSeg.selectedSegmentIndex = textAlignment;
            cell.accessoryView = textAlignSeg;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
		else{
            strokeSwitch.on = _labelMV.strokeColor?YES:NO;
            
            cell.accessoryView = strokeSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
		

	}
	else if(section == 3){
		textAlignSeg.selectedSegmentIndex = textAlignment;
		cell.accessoryView = textAlignSeg;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	cell.textLabel.text = [tableKeys[section] objectAtIndex:row];
	
	
	
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	
	int row = indexPath.row;
	int section = indexPath.section;
	
	if (section == 0 && row == 0) { // font
		if(!fontV){
			fontV = [[FontScrollView alloc]initWithFrame:self.view.bounds];
//			fontV.delegate = parent;
			fontVC = [[UIViewController alloc]init];
			fontVC.view = fontV;
		}

		[self.navigationController pushViewController:fontVC animated:YES];
	}
	else if(section == 0 && row == 1){ //text color
		if (!colorPlatteV) {
			colorPlatteV = [[MyColorPlatteView alloc] initWithFrame:self.view.bounds];
//			colorPlatteV.delegate = parent;
			colorPlatteV.layer.cornerRadius = 10;
			colorPlatteVC = [[UIViewController alloc]init];
			colorPlatteVC.view = colorPlatteV;
			
		}
//		colorMode = SettingColorModeText;
	
        [self.navigationController pushViewController:colorPlatteVC animated:YES];
	
    }
	else if(section == 1 && row == 0){ // bg color
		if (!colorPlatteV) {
			colorPlatteV = [[MyColorPlatteView alloc] initWithFrame:self.view.bounds];
//			colorPlatteV.delegate = parent;
			colorPlatteV.layer.cornerRadius = 10;
			colorPlatteVC = [[UIViewController alloc]init];
			colorPlatteVC.view = colorPlatteV;
			
		}
//		colorMode = SettingColorModeBG;
		[self.navigationController pushViewController:colorPlatteVC animated:YES];
	}
	
	// to change barbutton
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

#pragma mark - IBAction
- (IBAction)slideValueChanged:(UISlider*)sender{
   
    float newValue = sender.value;
    
    bgalpha = newValue;
    
}


#pragma mark - Navi
- (void)popBack{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)reload{
	[tv reloadData];
}
@end
