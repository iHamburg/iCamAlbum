//
//  ELCImagePickerDemoViewController.h
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"
#import "ViewController.h"
#import "ELCAlbumPickerController.h"



@interface ELCImagePickerDemoViewController : UIViewController <ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate> {

	IBOutlet UIScrollView *scrollview;
}

@property (nonatomic, unsafe_unretained) ViewController *rootVC;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) ELCImagePickerController *elcPicker;
@property (nonatomic, strong) ELCAlbumPickerController *albumController;



- (void)showViewController:(UIViewController *)controller;

@end

