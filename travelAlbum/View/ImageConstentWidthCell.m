//
//  FBAlbumCell.m
//  InstaMagazine
//
//  Created by AppDevelopper on 06.12.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "ImageConstentWidthCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageConstentWidthCell{
//    	CGFloat margin;
}

@synthesize margin;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

		margin = isPad?5:3;
    }
    return self;
}



- (void)layoutSubviews{

	[super layoutSubviews];
	
	CGFloat h = self.height;
	
    self.imageView.frame = CGRectMake(0,0,h,h);
//	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.layer.masksToBounds = YES;
	self.textLabel.frame = CGRectMake(h+margin, 0, self.width-h-margin, h);
}

@end
