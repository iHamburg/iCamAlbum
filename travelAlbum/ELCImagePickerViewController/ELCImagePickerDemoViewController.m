//
//  ELCImagePickerDemoViewController.m
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//


#import "ELCImagePickerDemoViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "Macros.h"
#import "Constant.h"
#import "UIImage+Extras.h"

@implementation ELCImagePickerDemoViewController

@synthesize rootVC;
@synthesize scrollview,elcPicker,albumController;



- (void)viewDidLoad{
    L();
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, 640, 480);
    self.contentSizeForViewInPopover = self.view.frame.size;
    

	albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];    
	elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController] ;
	elcPicker.view.frame = self.view.frame;
	[albumController setParent:elcPicker];
	[elcPicker setDelegate:self];

	
    [self.view addSubview:elcPicker.view];
    

}


#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
	
    L();
    
//	
//	NSMutableArray *imgs = [NSMutableArray array];
//	
//
//	for(NSDictionary *dict in info) {
//		
//		UIImage *img = [dict objectForKey:UIImagePickerControllerOriginalImage];
//		
//		NSURL *url = [dict objectForKey:@"UIImagePickerControllerReferenceURL"];
//		
////		PictureWithFrameView *v = [[PictureWithFrameView alloc] initWithImage:img];
//////		v.originalSize = img.size;
////		v.url = url;
////		[imgs addObject:v];
//    }
//	
////    DLog(@"imgVs:%@",imgs);
//    if (!ISEMPTY(imgs)) {
//
//		[[NSNotificationCenter defaultCenter]
//		              postNotificationName:NotifiAddPicture object:imgs];
//    }
//
//
//	[[NSNotificationCenter defaultCenter]
//	 postNotificationName:NotifiRootDismiss object:nil];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {

//    L();


//	[[NSNotificationCenter defaultCenter]
//	 postNotificationName:NotifiRootDismiss object:nil];
}

- (void)didReceiveMemoryWarning {
	L();
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	L();
}



#pragma mark -
- (void)showViewController:(UIViewController *)controller {
	[self presentModalViewController:controller animated:YES];
  //  [self.view addSubview:controller.view];
}
@end
