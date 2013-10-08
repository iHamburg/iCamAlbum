//
//  ChoiceTableViewController.h
//  InstaMagazine
//
//  Created by AppDevelopper on 24.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiceTableViewController : UITableViewController{
	NSNumber *tempStr;
}

@property (nonatomic, strong) NSArray *tableKeys;
@property (nonatomic, assign) int selectedIndex;

@end
