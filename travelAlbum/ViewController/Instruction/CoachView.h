//
//  CoachView.h
//  Everalbum
//
//  Created by AppDevelopper on 05.02.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CoachViewDelegate;
@interface CoachView : UIView{
	
	UIImageView *_bgV;

}

@property (nonatomic, unsafe_unretained) id<CoachViewDelegate> delegate;
@property (nonatomic, strong) UIImage *coachImage;


@end


@protocol CoachViewDelegate <NSObject>

- (void)coachViewDidClicked:(CoachView*)coachView;

@end