//
//  EAInfoViewController.h
//  Everalbum
//
//  Created by AppDevelopper on 13-9-3.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "InfoViewController.h"

@interface EAInfoViewController : InfoViewController<UITableViewDataSource,UITableViewDelegate>{
    UIView *topBar;
    UILabel *titleL;
    UITableView *tv;
    
    NSArray *tableIconNames;
    NSArray *tableTexts;
}

@end
