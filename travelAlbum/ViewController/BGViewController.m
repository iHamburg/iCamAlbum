//
//  BGViewController.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-9-13.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "BGViewController.h"

@interface BGViewController ()

@end

@implementation BGViewController

#define kTimerInterval 15

- (void)loadView{

    self.view = [[UIView alloc] initWithFrame:_r];
    
    bgImgNames = [self loadBGImageNames];
    
    bgV1 = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgV2 = [[UIImageView alloc] initWithFrame:self.view.bounds];

    currentImgName = [bgImgNames randomObject];
    bgV1.image = [UIImage imageWithSystemName:currentImgName];
    
    [self.view addSubview:bgV1];
}

- (void)viewDidAppear:(BOOL)animated{
//    L();
    
    [super viewDidAppear:animated];
    
    [self beginUpdate];
}

- (void)viewDidDisappear:(BOOL)animated{
    
//    L();
    [super viewDidDisappear:animated];
    [self stopUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update{
//    L();

    NSString *newImgName;
    do {
         newImgName = [bgImgNames randomObject];
    } while ([newImgName isEqualToString:currentImgName]);

    UIImageView *currentV;
    UIImageView *belowV;
    
    if (bgV1.superview) {
        currentV = bgV1;
        belowV = bgV2;
    }
    else{
        currentV = bgV2;
        belowV = bgV1;
    }

    belowV.image = [UIImage imageWithSystemName:newImgName];
    currentImgName = newImgName;
    
    [UIView transitionFromView:currentV toView:belowV duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        
    }];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(update) object:nil];
	[self performSelector:@selector(update) withObject:nil afterDelay:kTimerInterval];

}

- (void)beginUpdate{
//    L();
    [self stopUpdate];
    [self performSelector:@selector(update) withObject:nil afterDelay:kTimerInterval];
}
- (void)stopUpdate{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(update) object:nil];
    
}
- (NSArray*)loadBGImageNames{
    //    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString dataFilePath:@"Material.plist"]];
    //    return dict[@"PageBGs"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i<16; i++) {
        NSString *str = [NSString stringWithFormat:@"AlbumBG_%d.jpg",i];
        [arr addObject:str];
    }
    return arr;
}

- (void)dealloc{
    
}
@end
