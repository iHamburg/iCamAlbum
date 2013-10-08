//
//  InfoMoreAppCell.m
//  Everalbum
//
//  Created by AppDevelopper on 13-9-3.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "InfoMoreAppCell.h"
#import "MoreApp.h"

@implementation InfoMoreAppCell

- (void)setMoreApps:(NSArray *)moreApps{
    _moreApps = moreApps;
    
    CGFloat wB = 80*kIsPad2;
    int num = _moreApps.count;
    CGFloat yCenter = 70*kIsPad2;
    CGFloat offset = (_w - num * wB)/(num +1);
    
    for (int i = 0; i<[_moreApps count]; i++) {
        MoreApp *moreApp = _moreApps[i];
//        NSLog(@"imgname # %@",moreApp.imgName);
        UIButton *b = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:moreApp.imgName target:self action:@selector(buttonClicked:)];
        b.center = CGPointMake(wB/2+offset*(i+1) + wB*i, yCenter);
        b.tag = i;
//        [b setImage:kPlaceholderImage forState:UIControlStateNormal];
        
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(b.frame)-50, CGRectGetMaxY(b.frame), wB + 100, 30)];
        l.textAlignment = NSTextAlignmentCenter;
        l.text = moreApp.title;
        l.textColor = kColorLabelGray;
        l.font = [UIFont fontWithName:kFontName size:isPad?24:16];
        
        [self.contentView addSubview:b];
        [self.contentView addSubview:l];
    }

}

// h： 125x2
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _w, isPad?50:30)];
        titleL.text = @"More Apps";
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor = kColorLabelGray;
        titleL.font = [UIFont fontWithName:kFontName size:isPad?36:24];
        
        [self.contentView addSubview:titleL];

             
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClicked:(UIButton*)sender{
    L();
    int index = sender.tag;
    
    [_infoVC selectApp:_moreApps[index]];
}
@end
