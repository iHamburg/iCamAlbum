//
//  InfoCell.m
//  Everalbum
//
//  Created by AppDevelopper on 13-9-8.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "InfoCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation InfoCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
		margin = isPad?10:6;
    }
    return self;
}



- (void)layoutSubviews{
    
	[super layoutSubviews];
	
	CGFloat h = self.height;
//	NSLog(@"h # %f, margin # %F",h,margin);
    
    self.imageView.frame = CGRectMake(margin,margin,h - 2* margin,h - 2 *margin);
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
	self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + margin, 0, self.width-h-margin, h);
    
//    self.imageView.backgroundColor = [UIColor redColor];
//    NSLog(@"imagev # %@",self.imageView);
}
@end
