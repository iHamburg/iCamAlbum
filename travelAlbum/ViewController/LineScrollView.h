//
//  LineScrollView.h
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-12.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LineScrollViewDelegate;

@interface LineScrollView : UIScrollView{
    
    __unsafe_unretained id<LineScrollViewDelegate> _lineDelegate;
}

@property (nonatomic, unsafe_unretained) id<LineScrollViewDelegate> lineDelegate;

- (IBAction)handleTap:(id)sender;

@end

@protocol LineScrollViewDelegate <NSObject>

- (void)lineScrollView:(LineScrollView*)sv didSelectView:(UIView*)v;

@end