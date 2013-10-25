//
//  PhotoAlbum2ViewController.m
//  Everalbum
//
//  Created by AppDevelopper on 11.08.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import "AlbumsTableViewController.h"
#import "ImagePhotoTableViewController.h"
#import "AlbumPhotoTableViewController.h"
#import "FBPhotoTableViewController.h"
#import "FacebookManager.h"
#import "ImageConstentWidthCell.h"
#import "LoadingView.h"

@interface AlbumsTableViewController ()

@end

@implementation AlbumsTableViewController


- (UINavigationController*)nav{
    if (!_nav) {
        _nav = [[UINavigationController alloc]initWithRootViewController:self];
        _nav.view.frame = CGRectMake(0, 0, self.view.width, self.view.height + kHNavigationbar);

    }
    return _nav;
}

+(id)sharedInstance{
	static id sharedInstance;
	if (sharedInstance == nil) {
		
		sharedInstance = [[[self class] alloc]init];
	}
	
	return sharedInstance;
	
}

- (void)loadAssetsGroups
{
    /// 这里Library一定要存在
    library = [[ALAssetsLibrary alloc] init];
	
	/// 这个block会被多次调用
//	void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
//	{
//		if (group == nil)
//		{
//			return;
//		}
//        
//		[group setAssetsFilter:[ALAssetsFilter allPhotos]];
//		[assetGroups addObject:group];
//		
//		// Reload albums
//		
//		[tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
//		
//	};
//	
//	
//	// Group Enumerator Failure Block
//	void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
//		
//		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//		[alert show];
//        
//	};
	
	// Enumerate Albums， asyn
	[library enumerateGroupsWithTypes:ALAssetsGroupAll
						   usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if (group == nil)
         {
             return;
         }
         
         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
         [assetGroups addObject:group];
         
         // Reload albums
         
         [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
         
     }
         failureBlock:^(NSError *error) {
             
             UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [alert show];
             
    }];
}

- (void)loadFBAlbums{
    
   
    fbAlbums = [NSMutableArray array];
    [[FacebookManager sharedInstance]requestAlbums];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFBAlbums) name:kNotificationFinishRequestAlbums object:nil];
	
    
	self.view.frame = isPad? CGRectMake(0, 0, 345 , 480):CGRectMake(0, 0, _w, _h - kHNavigationbar);

    
	tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
    tableView.autoresizingMask = kAutoResize;
    tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
	[self.view addSubview:tableView];
	
	self.title = @"Photo Albums";
	
	sectionHeaders = @[@"Our Phots",@"Photo Albums",@"Facebook"];
	
	assetGroups = [NSMutableArray array];
    photoInputs = [NSMutableArray array];
	
    [self loadAssetsGroups];
 
	
}

- (void)dealloc{
    L();
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	if (section == 0) {

        if (isAlbumOpened) {
            return 4;
        }
        else
            return 1;
	}
	else if(section == 1){
        
		return [assetGroups count];
	}
	else{
		return 1;
	}
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return isPad?55:35;
}

- (void)layoutCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { //system
		cell.imageView.image = [UIImage imageNamed:@"icon_AlbumVC_photoalbum.png"];
		cell.textLabel.text = @"Our photos";
	}
  	else if (indexPath.section == 1){ //facebook
		ALAssetsGroup *g = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row];
		NSInteger gCount = [g numberOfAssets];
		
		cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], gCount];
		[cell.imageView setImage:[UIImage imageWithCGImage:[g posterImage]]];
        
	}
	else if(indexPath.section == 2){
		cell.imageView.image = [UIImage imageNamed:@"icon_shareFB2.png"];
		cell.textLabel.text = @"From Facebook";
		
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ImageConstentWidthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.font = [UIFont fontWithName:kFontName size:isPad?20:14];
		cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = kColorLabelBlue;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
    }
    
	[self layoutCell:cell indexPath:indexPath];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     
	
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Push



- (void)pushFBPhotoTableVCWithFBAlbum:(FBAlbum*)fbAlbum{

    
    PhotoTableViewController* imagePhotoTableVC = [[FBPhotoTableViewController alloc]init];
    imagePhotoTableVC.view.frame = self.view.bounds;
    imagePhotoTableVC.vc = self;
    imagePhotoTableVC.numOfColumn = _numOfColumn;
    imagePhotoTableVC.thumbSize = _thumbSize;
    imagePhotoTableVC.inputs = fbAlbum.fbPhotos;
    
    [self pushPhotoTableViewController:imagePhotoTableVC];
	
}


- (void)loadPhotoInputs:(PhotoTableViewController *)albumTableViewController group:(ALAssetsGroup*)group {
    dispatch_async(dispatch_get_main_queue(), ^{
		
		[photoInputs removeAllObjects];
		
		@autoreleasepool {
			
			[group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
			 {
				 if(asset == nil) {
					 return;
				 }
                 
                 //                 NSLog(@"in dispatch");
				 [photoInputs addObject:asset];
				 
			 }];
            
            // only once
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"back to main thread");
                
                [albumTableViewController reloadTableView];
            });
		}
		
	});
}

- (void)pushPhotoTableVCWithAssetsGroup:(ALAssetsGroup*)group{
 
    PhotoTableViewController* albumTableViewController = [[AlbumPhotoTableViewController alloc]init];
    albumTableViewController.view.frame = self.view.bounds;
    albumTableViewController.vc = self;
	albumTableViewController.title = [group valueForProperty:ALAssetsGroupPropertyName];
	
    [self loadPhotoInputs:albumTableViewController group:group];
    
    albumTableViewController.inputs = photoInputs;
    albumTableViewController.numOfColumn = _numOfColumn;
    albumTableViewController.thumbSize = _thumbSize;

    [albumTableViewController reloadTableView];
    [self pushPhotoTableViewController:albumTableViewController];

}


- (void)pushPhotoTableVCWithImgNames:(NSArray*)imgNames{
 
    PhotoTableViewController* imagePhotoTableVC = [[ImagePhotoTableViewController alloc]init];
    imagePhotoTableVC.view.frame = self.view.bounds;
    imagePhotoTableVC.vc = self;
    imagePhotoTableVC.inputs = imgNames;
    imagePhotoTableVC.numOfColumn = _numOfColumn;
    imagePhotoTableVC.thumbSize = _thumbSize;
    imagePhotoTableVC.title = APPNAME;
    
    [self pushPhotoTableViewController:imagePhotoTableVC];
    
}

#pragma mark -
- (IBAction)back:(id)sender{
    if ([_delegate respondsToSelector:@selector(albumTableViewControllerDidCancel:)]) {
        [_delegate albumTableViewControllerDidCancel:self];
    }
}

#pragma mark - FB
- (void)updateFBAlbums{
	
	L();
	FacebookManager *fbManager = [FacebookManager sharedInstance];
//	self.title = fbManager.fbUserName;
//	NSLog(@"self.title # %@",self.title);
    
    
    /// load all fbalbums
    fbAlbums = [NSMutableArray arrayWithArray:fbManager.fbAlbums];
    
	[tableView reloadData];
}


#pragma mark -
- (void)pushPhotoTableViewController:(UIViewController*)vc {
    vc.view.frame = self.view.bounds;
    vc.contentSizeForViewInPopover = CGSizeMake(vc.view.width, vc.view.height);
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)slideOut{
    [self.nav.view slideOut];
}

#pragma mark -

- (void)selectImage:(UIImage*)image{
    if ([_delegate respondsToSelector:@selector(albumTableViewController:didSelectedImage:)]) {
        [_delegate albumTableViewController:self didSelectedImage:image];
    }

}
- (void)selectFBPhoto:(id)fbPhoto{
    if ([_delegate respondsToSelector:@selector(albumTableViewController:didSelectedFBPhoto:)]) {
        [_delegate albumTableViewController:self didSelectedFBPhoto:fbPhoto];
    }
}

- (void)selectImgName:(NSString*)imgName{
    if ([_delegate respondsToSelector:@selector(albumTableViewController:didSelectedImgName:)]) {
        [_delegate albumTableViewController:self didSelectedImgName:imgName];
    }
}

- (void)selectALAsset:(ALAsset *)asset{
    if ([_delegate respondsToSelector:@selector(albumTableViewController:didSelectedALAsset:)]) {
        [_delegate albumTableViewController:self didSelectedALAsset:asset];
    }
}
@end
    