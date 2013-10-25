//
//  EditSideControlViewController.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-9-24.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "EditSideControlViewController.h"
#import "MomentChangeBGAlbumsTableViewController.h"
#import "ImageModelAlbumsViewController.h"

#import "LabelModelView.h"
#import "ImageModelView.h"

@interface EditSideControlViewController ()

@end

@implementation EditSideControlViewController



- (void)loadView{
    self.title = @"Edit Page";
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwSidebar, _h - kHNavigationbar)];
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    gesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:gesture];
    

   
    tv = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
//    tv.backgroundColor = [UIColor blackColor];
    
    tableKeys = @[kEditMenuBG,kEditMenuPhoto,kEditMenuText, kEditMenuAddCaption];
    
    [self.view addSubview:tv];
    
//    L();
//    NSLog(@"sideControl # %@",self.view);
//    
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    v.backgroundColor = [UIColor redColor];
//    [self.view addSubview:v];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated{
//    L();
    [super viewDidAppear:animated];
//    
//    L();
////    [tv setContentOffset:CGPointMake(0, 0)];
//    NSLog(@"sideControl # %@, tv # %@",self.view,tv);
}

- (void)viewDidDisappear:(BOOL)animated{
//    L();
    [super viewDidDisappear:animated];
}

- (void)dealloc{
    L();
}


#pragma mark -
#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	int num = [tableKeys count] ;
	
    
	return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat hCell = isPad?55:35;
	
	return hCell;
}
//


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier1 = @"Cell1";
    //	static NSString *CellIdentifier2 = @"Cell2";
    int row = indexPath.row;
	UITableViewCell *cell;
	
//	int section = indexPath.section;

    
    cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:kFontName size:isPad?20:14];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = kColorLabelBlue;
 
    }

    cell.textLabel.text = tableKeys[row];

	
	return cell;
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int row = indexPath.row;
    
    switch (row) {
        case 0: // change bg
            [self pushChangeBG];
            break;
        case 1: // add photo
            [self pushAddPhoto];
            
            break;
        case 2: // add text
            [_vc popTextEdit:[LabelModelView defaultInstance]];
        
        break;
            
        case 3: // add caption

            [_momentV setCaptionText:SDefaultCaptionText];
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - AlbumTableViewController
- (void)albumTableViewController:(AlbumsTableViewController *)photoAlbum didSelectedImgName:(NSString *)imgName{
    if (photoAlbum == changeBGATVC) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationChangeMomentBGImage object:imgName];
    }
    else if(photoAlbum == addPhotoATVC){

//        [_vc addPhoto:imgName];
        [_momentV addElementRandomed:[_momentV convertPhotoElementToImv:imgName]];
    }
}

- (void)albumTableViewController:(AlbumsTableViewController *)photoAlbum didSelectedALAsset:(ALAsset *)asset{
    if (photoAlbum == changeBGATVC) {
         [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationChangeMomentBGImage object:asset];
    }
    else if(photoAlbum == addPhotoATVC){

         [_momentV addElementRandomed:[_momentV convertPhotoElementToImv:asset]];
    }
}
#pragma mark - IBAction
- (IBAction)handleSwipe:(UISwipeGestureRecognizer*)sender{
    L();
    [_vc closeEditSideControl];
}
#pragma mark - Function
- (void)pushChangeBG{

    changeBGATVC = [[MomentChangeBGAlbumsTableViewController alloc] init];
    changeBGATVC.view.frame = self.view.bounds;
    changeBGATVC.title = SMomentChangeBG;
    changeBGATVC.delegate = self;
    changeBGATVC.imgNames = [self createPageBGImageNames];
    
    [self.navigationController pushViewController:changeBGATVC animated:YES];
    
}

- (NSArray*)createPageBGImageNames{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Material" ofType:@"plist"];
    NSDictionary *materialDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
    NSArray* pageBGNames = [materialDict objectForKey:@"PageBGs"];
    
    
    NSMutableArray *imgNames = [NSMutableArray array];
    [imgNames addObjectsFromArray:pageBGNames];

    
    return imgNames;
}

- (void)pushAddPhoto{
    addPhotoATVC = [[ImageModelAlbumsViewController alloc] init];
    addPhotoATVC.view.frame = self.view.bounds;
    addPhotoATVC.delegate = self;
    addPhotoATVC.imgNames = [self createStickerNames];
    
    [self.navigationController pushViewController:addPhotoATVC animated:YES];
    
}

- (NSArray*)createStickerNames{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Material" ofType:@"plist"];
    NSDictionary *materialDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *iconWidgetNames = materialDict[@"IconWidgets"];
    
    NSMutableArray* stickerNames = [NSMutableArray array];
    for (int i = 0; i< [iconWidgetNames count]; i++) {

        [stickerNames addObject:iconWidgetNames[i][@"name"]];
    }
    
    return stickerNames;
    
}
@end
