//
//  TextSettingViewController.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-12.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "TextSettingViewController.h"
#import "FontNameLineScrollView.h"
#import "ColorLineScrollView.h"

@implementation TextSettingViewController


- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _parent.view.width/2, _parent.view.height)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    sections = @[@"FontName",@"Text color",@"BGColor",@"BG Alpha",@"Text alignment"];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    tv.delegate = self;
    tv.dataSource = self;
    tv.autoresizingMask = kAutoResize;
    
    CGFloat wV = self.view.width - (isIOS7?20:40);
    CGFloat hV = 44;
    
    fontLSV = [[FontNameLineScrollView alloc] initWithFrame:CGRectMake(10, 0, wV, hV)];
    fontLSV.lineDelegate = self;
    
    textColorLSV = [[ColorLineScrollView alloc] initWithFrame:CGRectMake(10, 0, wV, hV)];
    textColorLSV.lineDelegate = self;
    
    bgColorLSV = [[ColorLineScrollView alloc] initWithFrame:CGRectMake(10, 0, wV, hV)];
    bgColorLSV.lineDelegate = self;
    
    bgAlphaSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    [bgAlphaSlider addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged];
     bgAlphaSlider.center = CGPointMake(self.view.width/2, 22);
    
    NSArray *imgNames = @[@"icon_alignLeft.png",@"icon_alignCenter.png",@"icon_alignRight.png"];
    
    NSMutableArray *imgs = [NSMutableArray array];
    for (NSString *imgName in imgNames) {
        UIImage *img = [UIImage imageWithContentsOfFileName:imgName];
        [imgs addObject:img];
        
    }
    
    textAlignSeg= [[UISegmentedControl alloc]initWithItems:imgs];
    textAlignSeg.center = CGPointMake(self.view.width/2, 22);
    [textAlignSeg addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:tv];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
 
}

- (void)viewDidAppear:(BOOL)animated{
    L();
    [super viewDidAppear:animated];
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [sections count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return sections[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    int section = indexPath.section;
    
    if (section == 0) { //font
        [cell.contentView addSubview:fontLSV];
    }
    else if(section == 1){ // text color
        [cell.contentView addSubview:textColorLSV];
    }
    else if(section == 2){ // bg color
        [cell.contentView addSubview:bgColorLSV];
    }
    else if(section == 3){ //alpha
        bgAlphaSlider.value = _bgAlpha;
        [cell.contentView addSubview:bgAlphaSlider];

    }
    else if(section == 4){
       
        [cell.contentView addSubview:textAlignSeg];
    }
    else{

    }
    
    return cell;
}

#pragma mark - LineScrollView
- (void)lineScrollView:(LineScrollView *)sv didSelectView:(UIView *)v{
    if (sv == fontLSV) {
        UILabel *l = (UILabel*)v;
        [_parent changeFontName:l.font.fontName];
    }
    else if(sv == textColorLSV){
        [_parent changeTextColor:v.backgroundColor];
    }
    else if(sv == bgColorLSV){
        [_parent changeBGColor:v.backgroundColor];
    }
}

- (IBAction)slideValueChanged:(UISlider*)sender{
//    L();
    NSLog(@"value # %f",sender.value);
    [_parent changeBGAlpha:sender.value];
}

- (IBAction)segmentValueChanged:(UISegmentedControl*)sender{
    L();
}

@end
