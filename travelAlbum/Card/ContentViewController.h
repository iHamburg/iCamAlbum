//
//  ContentViewController.h
//  XappCard
//
//  Created by  on 30.11.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CardViewController.h"



@interface ContentViewController : CardViewController{

	NSMutableArray *picArr;	
	
}


- (void)changeDefaultBG;

- (int)picNum;

@end


