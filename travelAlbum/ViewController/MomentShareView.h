//
//  MomentShareView.h
//  InstaMagazine
//
//  Created by AppDevelopper on 22.11.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MomentShareViewDelegate;

@interface MomentShareView : UIView{
	CGFloat w,h;
}

@property (nonatomic, strong) id<MomentShareViewDelegate> delegate;

@end

@protocol MomentShareViewDelegate <NSObject>

- (void)momentShareView:(MomentShareView*)view didShareWithType:(int)type;

@end