//
//  TextViewController.h
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-12.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WTEXTVC (isPad?780:_w)

@protocol TextVCDelegate;


@interface TextViewController : UIViewController{
    
    UILabel *_label;
    
    __unsafe_unretained id<TextVCDelegate> _delegate;
}

@property (nonatomic, unsafe_unretained) id<TextVCDelegate> delegate;
@property (nonatomic, strong) UILabel *label;

@end


@protocol TextVCDelegate <NSObject>

- (void)textVCDidCancel:(TextViewController*)textVC;
- (void)textVCDidChangeLabel:(UILabel*)label;

@end
