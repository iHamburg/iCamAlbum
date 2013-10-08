//
//  VerticalInstructionViewController.m
//  Everalbum
//
//  Created by AppDevelopper on 13-9-3.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "VerticalInstructionViewController.h"

@interface VerticalInstructionViewController ()

@end

@implementation VerticalInstructionViewController


- (void)loadView{
    self.view = [[UIView alloc]initWithFrame:_r];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
	scrollView.backgroundColor = [UIColor clearColor];
	scrollView.pagingEnabled = YES;
	scrollView.delegate = self;

	
    numOfPages = 7;
    NSMutableArray *imgNames = [NSMutableArray arrayWithCapacity:numOfPages];
    for (int  i = 1; i<numOfPages+1; i++) {
        [imgNames addObject:[NSString stringWithFormat:@"instruction-story%d.jpg",i]];
    }
	
		CGFloat wImage = isPad?960:480;
		CGFloat hImage = isPad?640:320;
		
		for (int i = 0; i<numOfPages; i++) {
			
			UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake((_w-wImage)/2,_h*i + (_h-hImage)/2, wImage, hImage)];
			imgV.image = [UIImage imageWithSystemName:imgNames[i]];

			
			[scrollView addSubview:imgV];
            scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(imgV.frame));
		}
        
	
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    gesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [scrollView addGestureRecognizer:gesture];
    

    [self.view addSubview:scrollView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"delegate # %@",_delegate);

}

- (void)handleSwipe:(UISwipeGestureRecognizer*)swipe{
    L();
}

#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    
//    NSLog(@"yOffset # %f",yOffset);
    CGFloat yValue = (numOfPages - 1)*_h;
    
    
    /// 会多次被调用！不是想要的。但是效果确是预计要达到的！
    if (yOffset>yValue ) {
        
        [scrollView setContentOffset:CGPointMake(0, (numOfPages-1)*_h) animated:NO];
        
        [_delegate instructionVCWillDismiss:self];

    }
}

@end
