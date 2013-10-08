//
//  PhotoAlbum2ViewController.h
//  Everalbum
//
//  Created by AppDevelopper on 11.08.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>


/**
 最上有searchbar，可以搜索web content
 
 1. 显示我们的图片 row ：1
 
 2. 显示所有的 photo album groups，row; numOfGroups
 
 3.1 如果facebook没有登陆，row ：1 =》From Facebook
 
 3.2 如果facebook登陆， row ：num Of facebook album
 
 */

@protocol AlbumsTableViewControllerDelegate;


@class FBAlbumsViewController,PhotoTableViewController;

@interface AlbumsTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{


	UITableView *tableView;
    
    PhotoTableViewController *photoTableVC;
    
   ALAssetsLibrary *library;
    
	NSMutableArray *assetGroups;  // array of assetGroups
    NSMutableArray *fbAlbums;       // array of FBAlbums
	
	NSArray *sectionHeaders;
    NSArray *_imgNames;          // get from delegate
    NSMutableArray *photoInputs; // self load for photo album
    
    BOOL isAlbumOpened;
    BOOL isFBAlbumOpen;
    
    
	CGSize _thumbSize;
    int _numOfColumn;
    
    __unsafe_unretained id<AlbumsTableViewControllerDelegate> _delegate;
}

+(id)sharedInstance;

@property (nonatomic, unsafe_unretained) id<AlbumsTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *imgNames;
@property (nonatomic, strong) UINavigationController *nav;


- (void)layoutCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)loadPhotoInputs:(PhotoTableViewController *)albumTableViewController group:(ALAssetsGroup*)group;
- (void)loadFBAlbums;

- (void)pushPhotoTableViewController:(UIViewController*)vc;

- (void)pushFBPhotoTableVCWithFBAlbum:(id)fbAlbum;
- (void)pushPhotoTableVCWithAssetsGroup:(ALAssetsGroup*)group;
- (void)pushPhotoTableVCWithImgNames:(NSArray*)imgNames;
- (void)slideOut;

- (void)selectImage:(UIImage*)image;
- (void)selectFBPhoto:(id)fbPhoto;
- (void)selectImgName:(NSString*)imgName;
- (void)selectALAsset:(ALAsset*)asset;

- (IBAction)back:(id)sender;
@end

@protocol AlbumsTableViewControllerDelegate <NSObject>

@optional


- (void)albumTableViewController:(AlbumsTableViewController*)photoAlbum didSelectedImage:(UIImage*)image;
- (void)albumTableViewController:(AlbumsTableViewController*)photoAlbum didSelectedFBPhoto:(id)fbPhoto;
- (void)albumTableViewController:(AlbumsTableViewController *)photoAlbum didSelectedALAsset:(ALAsset*)asset;
- (void)albumTableViewController:(AlbumsTableViewController *)photoAlbum didSelectedImgName:(NSString *)imgName;
- (void)albumTableViewControllerDidCancel:(AlbumsTableViewController*)photoAlbum;
@end

