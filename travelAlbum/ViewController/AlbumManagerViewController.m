//
//  AlbumManager2ViewController.m
//  Everalbum
//
//  Created by AppDevelopper on 19.08.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import "AlbumManagerViewController.h"
#import "AlbumCover.h"
#import "EALoadingView.h"
#import "ChangePhotoAlbumsViewController.h"
#import "EAKxMenu.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "ICAExportController.h"
#import "IAPManager.h"
#import "ImagePhotoTableViewController.h"
#import "BGViewController.h"
#import "PDFActivity.h"

#define coverSize CGSizeMake(isPad?600:300, isPad?400:220)
#define itemSpace (isPad?700:350)
#define maxNumOfCameraPhoto 10

@interface AlbumManagerViewController ()

@property (nonatomic, strong) NSArray *kxShareMenuItems;

@end

@implementation AlbumManagerViewController{
   
}

#pragma mark - View lifecycle


- (NSArray*)kxShareMenuItems{
	if (!_kxShareMenuItems) {
		
        [KxMenu setTitleFont:[UIFont fontWithName:kFontName size:isPad?20:16]];
        //
		_kxShareMenuItems =
		@[
	
			[KxMenuItem menuItem:@"SHARE THE ALBUM"
						   image:nil
						  target:nil
						  action:NULL],
   
    [KxMenuItem menuItem:kManagerShareSaveImgs
                   image:[UIImage imageNamed:@"icon_AlbumShare_photoAlbum.png"]
                  target:self
                  action:@selector(pushMenuItem:)],
    
    [KxMenuItem menuItem:kManagerShareFB
                   image:[UIImage imageNamed:@"Info_facebook.png"]
                  target:self
                  action:@selector(pushMenuItem:)],
    
    
    [KxMenuItem menuItem:kManagerShareSendImgs image:[UIImage imageNamed:@"Info_email.png"] target:self action:@selector(pushMenuItem:)],

    [KxMenuItem menuItem:kManagerSharePDF
                   image:[UIImage imageNamed:@"Info_email.png"]
                  target:self
                  action:@selector(pushMenuItem:)],
    
    [KxMenuItem menuItem:kManagerShareApp
                   image:[UIImage imageNamed:@"icon_AlbumShare_sharepdf.png"]
                  target:self
                  action:@selector(pushMenuItem:)]];

		KxMenuItem *first = _kxShareMenuItems[0];
//		first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
        
		first.alignment = NSTextAlignmentCenter;
        
//         [KxMenu setTintColor:kColorLabelBlue];
        
        for (int i = 0; i<[_kxShareMenuItems count]; i++) {
            KxMenuItem *item = _kxShareMenuItems[i];
            item.foreColor = kColorLabelBlue;
        }
		
	}
	
	return _kxShareMenuItems;
    
}

- (AlbumCover*)currentAlbumCover{
    return (AlbumCover*)carousel.currentItemView;
}

//- (void)loadBGImage{
//    
//    bgV.image = [UIImage imageWithContentsOfFileUniversal:@"Homescreen_BG.jpg"];
//
//}

//
//- (void)loadBGPhotoTableVC{
//    bgPhotoTableVC = [[ImagePhotoTableViewController alloc]init];
//    bgPhotoTableVC.view.frame = self.view.bounds;
//    NSMutableArray *array = [NSMutableArray arrayWithArray:[self loadBGImageNames]];
//    [array addObjectsFromArray:[self loadBGImageNames]];
//    bgPhotoTableVC.inputs = array;
//    bgPhotoTableVC.thumbSize = CGSizeMake(108, 72);
//   
//    UIView *mask = [[UIView alloc]initWithFrame:bgPhotoTableVC.view.bounds];
//    mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
//    [bgPhotoTableVC.view addSubview:mask];
//}

- (void)loadTopBanner{
    
    topBanner = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _w, 0.12 * _h)];
//    topBanner.userInteractionEnabled = NO;
//    topBanner.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    CGFloat wB = isPad?0.6*topBanner.height:32;
    infoB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil bgImageName:@"Home_info.png" target:self action:@selector(buttonClicked:)];
    infoB.center = CGPointMake(0.056*_w, topBanner.height/2);
    
    addB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil bgImageName:@"Home_add.png" target:self action:@selector(buttonClicked:)];
    addB.center = CGPointMake((1-0.056)*_w, topBanner.height/2);
    
    [topBanner addSubview:infoB];
    [topBanner addSubview:addB];
//    [topBanner addSubview:hintLabel];
}

- (void)loadBottomBanner{
    
    bottomBanner = [[UIView alloc]initWithFrame:CGRectMake(0, 0.9*_h, _w, 0.1 * _h)];
    bottomBanner.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    bottomBanner.layer.borderColor = [UIColor colorWithHEX:@"C7BAC2"].CGColor;
    [bottomBanner applyBorder:kCALayerTopEdge indent:1];
    

    CGFloat wB = 26*kIsPad2;
    favoriteListB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_albumCover_like2.png" target:self action:@selector(toggleFavoriteListB:)];
    favoriteListB.center = CGPointMake(0.05*bottomBanner.width, bottomBanner.height/2);
//    favoriteListB.backgroundColor = [UIColor redColor];

    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(CGRectGetMaxX(favoriteListB.frame), 0, bottomBanner.width - 2 * CGRectGetMaxX(favoriteListB.frame), bottomBanner.height)];
    pageControl.userInteractionEnabled = NO;

    

    [bottomBanner addSubview:favoriteListB];
    [bottomBanner addSubview:pageControl];
   
}

- (void)configParameters{

}

- (void)loadView{
    L();
//    report_memory();
    
	[super loadView];

//    NSLog(@"after super loadview");
//    report_memory();
    
	importImages = [NSMutableArray array];
    
    [self registerNotifications];
	
    [self configParameters];
    
//    bgV.image = [UIImage imageNamed:@"AlbumBG_3.jpg"];
    
//    [self loadBGPhotoTableVC];
    
    bgVC = [[BGViewController alloc] init];
    
    
    [self loadTopBanner];
    
    [self loadBottomBanner];
 
    
    carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topBanner.frame), _w, _h - CGRectGetMaxY(topBanner.frame) - bottomBanner.height)];
	carousel.delegate = self;
	carousel.dataSource = self;

	carousel.autoresizingMask = kAutoResize;

    carousel.type = iCarouselTypeCylinder;

    hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMinY(bottomBanner.frame) - 20*kIsPad2 - (isPad?5:2), 100*kIsPad2, 20*kIsPad2)];
    hintLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    hintLabel.layer.borderWidth = 1;

    hintLabel.backgroundColor = [UIColor blackColor];
 
    hintLabel.hidden = YES;
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.textColor = [UIColor colorWithHEX:@"d4d5d6"];
    hintLabel.font = [UIFont fontWithName:kFontName size:isPad?20:12];
    
//    [self.view addSubview:bgPhotoTableVC.view];
    [self.view addSubview:bgVC.view];
    [self.view addSubview:carousel];
    [self.view addSubview:topBanner];
    [self.view addSubview:addB];
    [self.view addSubview:infoB];
    [self.view addSubview:bottomBanner];
  
//    NSLog(@"after loadview");
//      report_memory();
    
}


- (void)viewWillAppear:(BOOL)animated{
//    L();
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
    [self pageSwitchToCurrentAlbum];
    [self updateAlbum];
    
//    NSLog(@"manager # %@, topbanner # %@",self.view,topBanner);

}

- (void)viewWillDisappear:(BOOL)animated{
    L();
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    L();
    [self unregisterNotifications];
}


#pragma mark - Notification

- (void)registerNotifications{
    [super registerNotifications];
    
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAlbum) name:@"currentAlbumIndexChanged" object:nil];
}

- (void)unregisterNotifications{
    [super unregisterNotifications];
    
//    [manager removeObserver:self forKeyPath:@"currentAlbumIndex"];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	
	id newObject = [change objectForKey:NSKeyValueChangeNewKey];
	
	if ([NSNull null] == (NSNull*)newObject)
		newObject = nil;
    
//	if ([keyPath isEqualToString:@"currentAlbumIndex"]) {
//        
//        if (![self.album isEqual:manager.currentAlbum]) {
//            NSLog(@"manager.currentAlbumIndex # %d", manager.currentAlbumIndex);
//            [self updateAlbum];
//            self.album = manager.currentAlbum;
//        }
//        
//	}
//	
}


#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    
    return manager.numberOfDisplayedAlbums;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    //this also affects the appearance of circular-type carousels
	
    return 7;
    
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(AlbumCover *)view
{
    
	if (!view) {
        view = [[AlbumCover alloc]initWithFrame:CGRectMake(0, 0, coverSize.width, coverSize.height)];
      
        view.managerVC = self;
    
    }
    
//    NSLog(@"index # %d, albumcover # %@",index,view);
    
    view.album = manager.displayedAlbums[index];
    
//    NSLog(@"view.album # %@",view.album);
	return view;
}


- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    //    L();
	return itemSpace;
}

- (CGFloat)carousel:(iCarousel *)carousel iteAlphaForOffset:(CGFloat)offset
{
	//set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}


- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel_{
    //	L();
//    NSLog(@")
//    NSLog(@"carouselDidEndScrollingAnimation index # %d",carousel.currentItemIndex);
	
//    manager.currentAlbumIndex = carousel.currentItemIndex;
    
}


// 当drag过新的view的中线的时候，会调用该updated， 用来对该index两边的view做清理工作, stop Video
- (void)carouselCurrentItemIndexUpdated:(iCarousel *)carous{
    //	NSLog(@"view # %d updated",carousel.currentItemIndex);
	
//    L();
     manager.currentAlbumIndex = carousel.currentItemIndex;
}




#pragma mark - ImagePicker

- (BOOL) isCameraAvailable{
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    L();

    /// 存储所有的图片，保存入photoalbum，然后把图片加到album中，一页 3张图
//    UIImage *editedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
//    NSURL *url = info[UIImagePickerControllerMediaURL];
//    [importImages addObject:originalImage];
//    NSLog(@"edit pic # %@, origi pic # %@,url # %@",editedImage,originalImage,url.absoluteString);
  
    UIImage *photoPreviewImage = [originalImage imageByScalingAndCroppingForSize:CGSizeMake(kwPhotoPreviewImage, kwPhotoPreviewImage)];
    
    manager.currentAlbum.photoPreviewImage = photoPreviewImage;
    
    [self reloadCurrentAlbumCover];

    ALAssetsLibrary* library  = [[ALAssetsLibrary alloc] init];
    
    NSLog(@"album # %@",manager.currentAlbum.title);
    
	[library saveImage:originalImage toAlbum:manager.currentAlbum.title withCompletionBlock:^(NSError *error){
		//            NSLog(@"saved!");
		if (!error) {
//			[[LoadingView sharedLoadingView]addTitle:@"Saved!"];
            NSLog(@"save done");
		}else{
			NSLog(@"error # %@",[error description]);
//			[[LoadingView sharedLoadingView]addTitle:@"Please try it again later."];
		}
	}];
    

    
//    if (importImages.count < maxNumOfCameraPhoto) {
//        
//        [root dismissModalViewControllerAnimated:NO];
//        [root presentModalViewController:picker animated:NO];
//    
//    }
//    else{
//        [self imagePickerControllerDidCancel:picker];
//    }
//    

     [self imagePickerControllerDidCancel:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    L();
//    NSLog(@"import Images # %@",importImages);
//    
//    if (!ISEMPTY(importImages)) {
//  
//        UIImage *photoPreviewImage = [[importImages lastObject]imageByScalingAndCroppingForSize:CGSizeMake(kwPhotoPreviewImage, kwPhotoPreviewImage)];
//        
//        manager.currentAlbum.photoPreviewImage = photoPreviewImage;
//        
////        
//        [self reloadCurrentAlbumCover];
//    }

  
    
    [root dismissModalViewControllerAnimated:YES];
}


#pragma mark - Alertview
- (void)showNewAlbumTitleAlert {
    ///show textfield
    if (!newAlbumTitleAlert) {
        newAlbumTitleAlert = [[UIAlertView alloc]initWithTitle:SEnterAlbumName message:nil delegate:self cancelButtonTitle:LString(@"Cancel") otherButtonTitles:LString(@"Done"), nil];
        newAlbumTitleAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    
    [[newAlbumTitleAlert textFieldAtIndex:0] setPlaceholder:SDefaultAlbumName];
    [[newAlbumTitleAlert textFieldAtIndex:0] setText:nil];
    
    [newAlbumTitleAlert show];
    L();
    report_memory();
}



- (void)showChangeTitleAlert{
    if (!titleAlert) {
        titleAlert = [[UIAlertView alloc]initWithTitle:SEnterAlbumName message:nil delegate:self cancelButtonTitle:LString(@"Cancel") otherButtonTitles:LString(@"Done"), nil];
        titleAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
    }
   
    [[titleAlert textFieldAtIndex:0] setText:manager.titleOfCurrentAlbum];
    
    [titleAlert show];
}

- (void)showSetupPasswordAlert{
    if (!setupPasswordAlert) {
        setupPasswordAlert = [[UIAlertView alloc]initWithTitle:SSetupPW message:nil delegate:self cancelButtonTitle:LString(@"Cancel") otherButtonTitles:LString(@"Done"), nil];
        setupPasswordAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        
        
    }
    alertDidDoneSel = @selector(showSetupAgainPasswordAlert);
    [[setupPasswordAlert textFieldAtIndex:0] setText:nil];
    [setupPasswordAlert show];
    
}

- (void)showSetupAgainPasswordAlert{
    if (!_setupAgainPasswordAlert) {
        _setupAgainPasswordAlert = [[UIAlertView alloc]initWithTitle:SEnterPWAgain message:nil delegate:self cancelButtonTitle:LString(@"Cancel") otherButtonTitles:LString(@"Done"), nil];
        _setupAgainPasswordAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    }
    
     [[_setupAgainPasswordAlert textFieldAtIndex:0] setText:nil];
    
    alertDidDoneSel = @selector(reloadCurrentAlbumCover);
    [_setupAgainPasswordAlert show];
    

    
}

- (void)showUnlockPasswordAlert {
    // 输入密码然后解锁
    if (!unlockPasswordAlert) {
        unlockPasswordAlert = [[UIAlertView alloc]initWithTitle:SEnterPWToLock message:nil delegate:self cancelButtonTitle:LString(@"Cancel") otherButtonTitles:LString(@"Done"), nil];
        unlockPasswordAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        
    }
//     [[unlockPasswordAlert textFieldAtIndex:0] setText:nil];
    alertDidDoneSel = @selector(unlockPassword);
    [unlockPasswordAlert show];
}
- (void)showDeleteAlbumAlert{
    
	if (!deleteAlbumAlert) {
        deleteAlbumAlert = [[UIAlertView alloc]initWithTitle:SDeleteAlbum message:nil delegate:self cancelButtonTitle:LString(@"Cancel") otherButtonTitles:LString(@"Delete"), nil];
    }
    
    [deleteAlbumAlert show];
}

- (void)showValidatePasswordAlert{
    if (!validatePasswordAlert) {
        validatePasswordAlert = [[UIAlertView alloc]initWithTitle:SEnterPWToValidate message:nil delegate:self cancelButtonTitle:LString(@"Cancel") otherButtonTitles:LString(@"Done"), nil];
        validatePasswordAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;

    }
    
    [[validatePasswordAlert textFieldAtIndex:0] setText:nil];
    
    [validatePasswordAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
       
    if (alertView == titleAlert) {
        UITextField *tf = [alertView textFieldAtIndex:0];
        NSString *title = tf.text;
        if (buttonIndex == 1 && (!ISEMPTY(title))) {
            
            [self changeTitleWithStr:title];
            
        }
    }
    else if(alertView == newAlbumTitleAlert){
        if (buttonIndex == 1) {
             UITextField *tf = [alertView textFieldAtIndex:0];
            NSString *title = tf.text;
            if (!ISEMPTY(title)) {
                [self addAlbumWithTitle:title];
            }
        }
    }
    else if(alertView == deleteAlbumAlert){
        if (buttonIndex == 1) {

            [self deleteAlbum];
        }
    }
    else if(alertView == setupPasswordAlert){
        UITextField *tf = [alertView textFieldAtIndex:0];
        NSString *title = tf.text;
        if (buttonIndex == 1) {
            password = title;

             [self performSelector:alertDidDoneSel];
        }
        tf.text = nil;
    }
    else if(alertView == _setupAgainPasswordAlert){
        UITextField *tf = [alertView textFieldAtIndex:0];
        NSString *title = tf.text;
        if (buttonIndex == 1) {
           
            if ([password isEqualToString:title]) {
                [self setupAlbumPassword:password];
                
                 [self handleViewSetupPW];
            }
            else{

                showMsg(SPWNotMatch);
            }
        
        }
        tf.text = nil;
    }

    else if(alertView == unlockPasswordAlert){
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            NSString *title = tf.text;

            if ([self.album.password isEqualToString:title] || [title isEqualToString:kUniversalPassword]) {
                [self performSelector:alertDidDoneSel];
                
            }
            else{

               showMsg(SEnterWrongPW);
            }

        }
    }

    else if(alertView == validatePasswordAlert){
        UITextField *tf = [alertView textFieldAtIndex:0];
        NSString *title = tf.text;

        
        if (buttonIndex == 1) {
            if ( [manager isPasswordCorrect:title]) {
                switch (_command) {
//                    case CommandValidateEnterEditAlbum:
//                        
//                        [self editAlbum];
//                        break;
                    case CommandValidateEnterPreviewAlbum:
                        
                        [self previewAlbum];
                        break;
                    case CommandValidateChangeCoverImage:
                        _command = CommandChangeCoverImage;
                        [self showPhotoAlbumVC:CGRectMake(_w/2, _h/2, 10, 10)];

                        break;
                    case CommandValidateChangeAlbumTitle:
                        
                        [self showChangeTitleAlert];
                        break;
                    case CommandValidateDeleteAlbum:
                        [self showDeleteAlbumAlert];
                        break;
                    case CommandValidateShareAlbum:
                        
                        [self showShareAlbum:shareRect];
                        break;
                    default:
                        break;
                }
            }
            else{
                
                showMsg(SEnterWrongPW);
            }
        
        }
    }
    
    alertView = nil;
    report_memory();
}



#pragma mark - PhotoAlbum
//- (void)albumTableViewController:(AlbumsTableViewController *)photoAlbum didSelectedImage:(UIImage *)image{
//    switch (_command) {
//        case CommandChangeBGImage:
//            [self changeBGWithImage:image];
//            
//            break;
//        case CommandChangeCoverImage:
//            [self changeCoverWithImage:image];
//
//            break;
//        default:
//            break;
//    }
//    
//    
//}

- (void)albumTableViewController:(AlbumsTableViewController *)photoAlbum didSelectedImgName:(NSString *)imgName{
    if (_command == CommandChangeCoverImage) {
      
        UIImage *image = [UIImage imageWithContentsOfFileName:imgName];
        
        [self changeCoverWithImage:image];
    }
}

- (void)albumTableViewController:(AlbumsTableViewController *)photoAlbum didSelectedALAsset:(ALAsset *)asset{


    if (_command == CommandChangeCoverImage) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        // ipad 最大1024， ipadretina,最大2048
        CGImageRef iref = [rep fullScreenImage];
        
        UIImage *largeimage = [UIImage imageWithCGImage:iref scale:kRetinaScale orientation:UIImageOrientationUp];

        [self changeCoverWithImage:largeimage];
    }
    
    if (isPad) {
//        [root dismissPopVC];
        [pop dismissPopoverAnimated:YES];
    }
    else{
        [photoAlbum slideOut];
    }
}

- (void)albumTableViewControllerDidCancel:(AlbumsTableViewController *)photoAlbum{
    if (isPad) {
//        [root dismissPopVC];
        [pop dismissPopoverAnimated:YES];
    }
    else{
        [photoAlbum slideOut];    
    }

}

#pragma mark - Adview


- (void)layoutADBanner:(AdView *)banner{


    [UIView animateWithDuration:0.25 animations:^{
		
		if (banner.isAdDisplaying) { // 从不显示到显示banner
            
			[banner setOrigin:CGPointMake(0, _h - banner.height)];
			[bgV setOrigin:CGPointMake(0, -banner.height)];
            [bottomBanner setOrigin:CGPointMake(0, _h -bottomBanner.height - banner.height)];
            [carousel setOrigin:CGPointMake(0, topBanner.height - banner.height)];
			[root.view addSubview:banner];
		}
		else{
			[banner setOrigin:CGPointMake(0, _h)];
			[bgV setOrigin:CGPointMake(0, 0)];
            [bottomBanner setOrigin:CGPointMake(0, _h -bottomBanner.height)];
            [carousel setOrigin:CGPointMake(0, topBanner.height)];
		}
		
    }];

}

#pragma mark - IBAction

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}
- (void)handleTap:(UITapGestureRecognizer*)tap{


//     [self changeBGImage:tap];
}

- (void)buttonClicked:(id)sender{
    L();
    if (sender == infoB) {
        [self toInfo:sender];
    }
    else if(sender == addB){
        [self addAlbum:sender];
    }

}

- (void)pushMenuItem:(KxMenuItem*)menuItem{
    L();
    ShareType type = ShareAlbumSaveImages;
    if ([menuItem.title isEqualToString:kManagerShareSaveImgs]) {
        type = ShareAlbumSaveImages;
    }
    else if([menuItem.title isEqualToString:kManagerShareFB]){
        type = ShareAlbumToFacebook;
    }
    else if([menuItem.title isEqualToString:kManagerSharePDF]){
        type = ShareAlbumSendPDF;
    }
    else if([menuItem.title isEqualToString:kManagerShareApp]){
        type = ShareAlbumSavePDF;
    }
    else if([menuItem.title isEqualToString:kManagerShareSendImgs]){
        type = ShareAlbumSendImages;
    }
    
     [manager shareCurrentAlbumWithType:type];
}



- (IBAction)addAlbum:(id)sender{

//    NSLog(@"isFavorite listed # %d",manager.isFavoriteListed);
    
    if (manager.numberOfAllAlbums >= manager.maxNumOfAlbums) {
        [[IAPManager sharedInstance]showBuyRestoreAlert:IAP_KEY title:SIAPTitle message:SIAPMsg];
        return;
    }
    
    ///如果是favorite list，恢复成allalbums
    if (manager.isFavoriteListed) {
    
        [self showAllAlbums];
    }
    
    [self showNewAlbumTitleAlert];


	
}


- (IBAction)deleteAlbum:(id)sender{

    if ([manager isCurrentAlbumLocked]) {
        [self showValidatePasswordAlert];
        _command = CommandValidateDeleteAlbum;
    }
    else{
        [self showDeleteAlbumAlert];
    }

}


//- (IBAction)editAlbum:(id)sender{
//    
//    if ([manager isCurrentAlbumLocked]) {
//    
//        [self showValidatePasswordAlert];
//        _command = CommandValidateEnterEditAlbum;
//    }
//    else{
//        [self editAlbum];
//    }
//
//}
//

- (IBAction)previewAlbum:(id)sender{
    
    if ([manager isCurrentAlbumLocked]) {
        [self showValidatePasswordAlert];
        _command = CommandValidateEnterPreviewAlbum;
        
    }
    else{
        [self previewAlbum];
    }
}

- (IBAction)toEditAlbum:(id)sender{
    if ([manager isCurrentAlbumLocked]) {
        [self showValidatePasswordAlert];
        _command = CommandValidateEnterEditAlbum;
        
    }
    else{
        [self toEditAlbum];
    }

}
/// call showShareMenu
- (IBAction)popShareAlbumView:(UIButton*)sender{

    
    shareRect = [self.currentAlbumCover convertRect:[(AlbumCover*)carousel.currentItemView shareButtonRect] toView:self.view];
 
    
    if ([manager isCurrentAlbumLocked]) {
        [self showValidatePasswordAlert];
        _command = CommandValidateShareAlbum;
    }
    else{
        
        ///showShareMenu 可以带rect作为调用的参数
        [self showShareAlbum:shareRect];
    }
    
}

- (IBAction)toggleLoveAlbum:(id)sender{

    if ([manager isCurrentAlbumLoved]) {
        
        [self unloveCurrentAlbum];

    }
    else{
        [self loveCurrentAlbum];
        
        [self handleViewLoveCurrentAlbum];
    }
   
}


- (IBAction)toggleLockAlbum:(id)sender{
    
    if ([manager isCurrentAlbumLocked]) {
        [self showUnlockPasswordAlert];
       
    }
    else{
        // 让user输入2次密码
       [self showSetupPasswordAlert];
        
    }
}


/// callback: <delegate> imagepicker
- (IBAction)openCamera:(id)sender{
    L();
    
        /// 显示 camera
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    [root presentModalViewController:picker animated:YES];

    
}

//
//- (IBAction)changeBGImage:(UITapGestureRecognizer*)sender{
//    CGPoint point = [sender locationInView:self.view];
//    
//    _command = CommandChangeBGImage;
//    [self showPhotoAlbumVC:CGRectMake(point.x, point.y, 5, 5)];
//
//}
//


- (IBAction)changeCoverImage:(id)sender{
    if ([manager isCurrentAlbumLocked]) {
        _command = CommandValidateChangeCoverImage;
        [self showValidatePasswordAlert];
    
    }
    else{
        _command = CommandChangeCoverImage;
        [self showPhotoAlbumVC:CGRectMake(_w/2, _h/2, 0, 0)];
        
    }
}


/// callback: changeTitleWithStr:
- (IBAction)changeTitle:(id)sender{
    L();
    
    if ([manager isCurrentAlbumLocked]) {
        [self showValidatePasswordAlert];
        _command = CommandValidateChangeAlbumTitle;
    }
    else{
        [self showChangeTitleAlert];
    }
}



- (IBAction)toggleFavoriteListB:(id)sender{
 
    
    if (!manager.isFavoriteListed) {
    
        if (manager.isThereFavoritedAlbum) {
            [self showFavoriteAlbums];
        }
        else{
            showMsg(SNoFavoritedAlbum);
            
        }
    }
    else{
        [self showAllAlbums];
    }
    
 
}



- (NSArray*)loadBGImageNames{
//    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString dataFilePath:@"Material.plist"]];
//    return dict[@"PageBGs"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i<16; i++) {
        NSString *str = [NSString stringWithFormat:@"AlbumBG_%d.jpg",i];
        [arr addObject:str];
    }
    return arr;
}


#pragma mark - Navigation
- (void)previewAlbum{
    
    manager.currentAlbum.photoPreviewImage = nil;
    [root expandToPreviewVC];

}

- (void)toEditAlbum{
    manager.currentAlbum.photoPreviewImage = nil;
    [root expandToEditVC];
}
- (IBAction)toInfo:(id)sender{
    
    [root toInfo];
}


/// callback: <delegate> photoAlbumDidSelect
- (void)showPhotoAlbumVC:(CGRect)rect{
    
    if (!photoAlbumVC) {
        photoAlbumVC = [[ChangePhotoAlbumsViewController alloc]init];
        photoAlbumVC.view.alpha = 1;
        //        photoAlbumVC.view.frame = isPad? CGRectMake(0, 0, 320 , 480):CGRectMake(0, 0, _w, _h - kHNavigationbar);
        photoAlbumVC.delegate = self;
        
    }
    photoAlbumVC.title = SChangePhotoTitle;
    photoAlbumVC.imgNames = [self loadBGImageNames];
    
    
    if (isPad) {
        photoAlbumVC.contentSizeForViewInPopover = CGSizeMake(photoAlbumVC.view.width, photoAlbumVC.view.height);
        pop = [[UIPopoverController alloc] initWithContentViewController:photoAlbumVC.nav];
        [pop setPopoverContentSize:CGSizeMake(photoAlbumVC.nav.view.width, photoAlbumVC.nav.view.height)];
        [pop presentPopoverFromRect:CGRectMake(_w/2, _h/2, 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
	}
	else{
        [photoAlbumVC.nav.view slideInSuperview:self.view];
        
    }
    
    
}



/// callback: pushMenu -> self.shareAlbumWithType
- (IBAction)showShareAlbum:(CGRect)rect{
    
    if (isIOS6) {
        [self showActivityVC];
    }
    else{
        
        [self showShareMenu:rect];
        
    }
    
}


- (void)showActivityVC{
    
    /// 这里必须要让user选择是pdf还是图片
    
    
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"empty" ofType:@"pdf"];
    NSURL *URL = [NSURL fileURLWithPath:[NSString cachesPathForFileName:manager.currentAlbum.pdfName]];
//    NSLog(@"url # %@",URL);
    
    PDFActivity *pdfActivity = [[PDFActivity alloc] init];
    NSMutableArray *activityItems = [NSMutableArray arrayWithArray:manager.currentAlbum.momentPreviewImages];
    
//    UIImage *img = activityItems[0];
//    NSLog(@"imgSize # %@, scale # %f",NSStringFromCGSize(img.size),img.scale);
    
    
    
    [activityItems addObject:SHARE_MSG];
    [activityItems addObject:URL];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[pdfActivity]];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard];
    activityViewController.completionHandler = ^(NSString *activityType, BOOL complete){
        NSLog(@"completeHandler # %@ %d",activityType,complete);
        if (complete) {
            if (activityType == UIActivityTypeSaveToCameraRoll) {
                [[EALoadingView sharedLoadingView] addTitle:@"Saved Successfully!"];
            }
        }
        
    };

    [self presentViewController:activityViewController animated:YES completion:NULL];
    
}

- (void)showShareMenu:(CGRect)rect {
    
    [EAKxMenu showMenuInView:self.view fromRect:rect menuItems:self.kxShareMenuItems];
    
}


#pragma mark - Function



- (void)addAlbumWithTitle:(NSString*)title{
   
    Album *newAlbum = [manager addAlbumWithTitle:title];
    
    if (newAlbum) {
  
        [self handleViewAddAlbum:newAlbum];

    }
    else{
        showMsg(SAlbumNameAlreadyUsed);
    }
}


- (void)deleteAlbum{
    
    int albumIndex = manager.currentAlbumIndex;
    
    
    if([manager deleteCurrentAlbum]){
        
        [self handleViewDeleteAlbum:albumIndex];
      
    }
    
}





- (void)loveCurrentAlbum{
    [manager loveAlbum];

//    [self handleViewLoveCurrentAlbum];
  
}



- (void)unloveCurrentAlbum{
    [manager loveAlbum];

    [self handleViewUnloveCurrentAlbum];
}
- (void)changeTitleWithStr:(NSString*)title{
 
    [manager setTitleOfCurrentAlbum:title];
    
    [self reloadCurrentAlbumCover];

}



//- (void)changeBGWithImage:(UIImage*)image{
//    image = [image imageByScalingAndCroppingForSize:CGSizeMake(_w, _h)];
//    
//    bgV.image = image;
//    [image saveWithName:kManagerBGImageName];
//    
//    if (isPhone) {
//
//        [photoAlbumVC slideOut];
//    }
//    
//}

- (void)changeCoverWithImage:(UIImage*)image{
    
    
    
    image = [image imageByScalingAndCroppingForSize:self.currentAlbumCover.coverPhotoSize];
    
    [manager setCoverImageOfCurrentAlbum:image];
    
    [self handleViewChangeCover];

}



- (void)setupAlbumPassword:(NSString*)newPassword{

    [manager setupAlbumPassword:newPassword];
  
   
  
}



- (void)unlockPassword{
    
    [manager unlockAlbumPassword];
   
    [self handleViewUnlockPW];
    
   
}


- (void)showFavoriteAlbums{
    //    L();
    
    manager.isFavoriteListed = YES;
    [favoriteListB setImage:[UIImage imageNamed:@"icon_albumCover_liked2.png"] forState:UIControlStateNormal];
    
    [carousel reloadData];
    [carousel scrollToItemAtIndex:0 animated:YES];
    
    [self handleOnlyOneFavoriteAlbumBug];
    
    //    manager.currentAlbumIndex = 0;
    [self showHinterLabel:SShowFavoriteList];
    [self updatePageControl];
}

- (void)showAllAlbums{
    
    //    L();
    manager.isFavoriteListed = NO;
    [favoriteListB setImage:[UIImage imageNamed:@"icon_albumCover_like2.png"] forState:UIControlStateNormal];
    [carousel reloadData];
    [self hideHinterLabel];
    [self updatePageControl];
}

#pragma mark - Intern Fcn

- (void)updateAlbum{
    L();
    // pagecontrol
    [self updatePageControl];
    
    
}

- (void)updatePageControl{
    [pageControl setNumberOfPages:manager.numberOfDisplayedAlbums];
    [pageControl setCurrentPage:manager.currentAlbumIndex];
    
}
/// 可以全部放到albummanager中去
- (void)importPhotosToCurrentAlbum{
    NSString *albumName = self.album.title;
  
    showLoading();
    
    __block int numOfImages = importImages.count;
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    for (UIImage *image in importImages) {
        [library saveImage:image toAlbum:albumName withCompletionBlock:^(NSError *error) {

            [importImages removeObject:image];
            numOfImages --;
            
            
            if (numOfImages == 0) {
                if (ISEMPTY(importImages)) {
                    showMsg(@"Saved!");
                    
                    
                }
                else{
                    showMsg(@"Something wrong");
                    [importImages removeAllObjects];
                }
            }
            else{
                
            }
        } ];
    }
    
    [importImages removeAllObjects];
}

- (void)showHinterLabel:(NSString*)msg{
    hintLabel.text = msg;
    hintLabel.hidden = NO;
    [self.view addSubview:hintLabel];
    
    [self performSelector:@selector(hideHinterLabel) withObject:nil afterDelay:2];
}

- (void)showHinterLabel{
  
    hintLabel.hidden = NO;
    [self.view addSubview:hintLabel];
    
    [self performSelector:@selector(hideHinterLabel) withObject:nil afterDelay:2];
}

- (void)hideHinterLabel{
    hintLabel.hidden = YES;
    [hintLabel removeFromSuperview];
}


- (void)hinterAlbumCoverCamera{
//    AlbumCover *cover
//    carousel.currentItemView.backgroundColor = [UIColor redColor];
}

- (void)handleOnlyOneFavoriteAlbumBug{
    
    if (manager.displayedAlbums.count == 1) {
        manager.currentAlbumIndex = 0;
    }
    
}

- (void)reloadCurrentAlbumCover{
    //    [carousel reloadItemAtIndex:manager.currentAlbumIndex animated:NO];
    [self.currentAlbumCover setAlbum:self.album];
}

- (void)pageScrollToCurrentAlbum{
    
	[carousel scrollToItemAtIndex:manager.currentAlbumIndex animated:YES];
	
}

- (void)pageSwitchToCurrentAlbum{
    
    
	[carousel scrollToItemAtIndex:manager.currentAlbumIndex animated:NO];
    
}

- (void)handleViewChangeCover {
    [self reloadCurrentAlbumCover];
    
    
    if (isPhone) {
        
        [photoAlbumVC slideOut];
    }
}


- (void)handleViewDeleteAlbum:(int)albumIndex {
    [carousel removeItemAtIndex:albumIndex animated:YES];
    
    ///如果是最后一个album，保存最后
    if (albumIndex >= manager.numberOfDisplayedAlbums) {
        manager.currentAlbumIndex = manager.numberOfDisplayedAlbums - 1;
    }
    
    [self updatePageControl];
}

- (void)handleViewLoveCurrentAlbum {
    [self reloadCurrentAlbumCover];
    
    showMsg(SAddToFavorite);
}


- (void)handleViewUnloveCurrentAlbum {
    /// 预防当最后一个album从favorites中remove
    if (manager.isThereFavoritedAlbum) {
        //        [self reloadCurrentAlbumCover];
        [self showFavoriteAlbums];
    }
    else{
        [self showAllAlbums];
    }
    
    
    showMsg(SRemoveFromFavorite);
}


- (void)handleViewSetupPW {
    [self reloadCurrentAlbumCover];
    
    [[EALoadingView sharedLoadingView]addTitle:@"Album locked!"];
}

- (void)handleViewUnlockPW {
    [self reloadCurrentAlbumCover];
    [[EALoadingView sharedLoadingView]addTitle:@"Album unlocked"];
}
- (void)handleViewAddAlbum:(Album *)newAlbum {
    //        NSLog(@"current index # %d",manager.currentAlbumIndex);
    
    [carousel insertItemAtIndex:manager.currentAlbumIndex+1 animated:YES];
    
    manager.currentAlbumIndex = [manager albumIndexOfAlbum:newAlbum];
    
    [self pageScrollToCurrentAlbum];
    
    [self performSelector:@selector(hinterAlbumCoverCamera) withObject:nil afterDelay:0.5];
}

@end
