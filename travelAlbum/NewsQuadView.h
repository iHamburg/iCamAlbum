//
//  NewsQuadView.h
//  MusterProject
//
//  Created by AppDevelopper on 26.06.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsQuadView : UIView{
	
	UIImageView *imgV;
	UILabel *textLabel;
	UILabel *detailTextLabel;

}

@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;


@end
