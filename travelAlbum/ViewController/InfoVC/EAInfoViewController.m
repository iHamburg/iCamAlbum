//
//  EAInfoViewController.m
//  Everalbum
//
//  Created by AppDevelopper on 13-9-3.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "EAInfoViewController.h"
#import "MoreApp.h"
#import "InfoMoreAppCell.h"
#import "InfoCell.h"

@interface EAInfoViewController ()

@end

@implementation EAInfoViewController

- (void)loadTopBar{
    topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _w, isPad?55:32)];
    topBar.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat wB = isPad?40:30;
    backB = [UIButton buttonWithFrame:CGRectMake(5*kIsPad2, 5*kIsPad2, wB, wB) title:nil imageName:@"icon_blueBack.png" target:self action:@selector(back)];
    
    titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _w - 2* CGRectGetMaxX(backB.frame), topBar.height)];
    titleL.center = CGPointMake(topBar.width/2, topBar.height/2);
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = @"INFO";
    titleL.backgroundColor = [UIColor clearColor];
    titleL.font = [UIFont fontWithName:kFontName size:isPad?40:26];
    titleL.textColor = kColorLabelBlue;
    
    [topBar addSubview:titleL];
    [topBar addSubview:backB];
    
    
}

- (void)loadMoreApps{
    NSArray *moreAppNames;

    moreAppNames = @[@"myecard",@"tinykitchen",@"nsc"];
    
    NSString *moreAppsPlistPath = [[NSBundle mainBundle] pathForResource:@"MoreApps.plist" ofType:nil];
	NSDictionary *moreAppsDict = [NSDictionary dictionaryWithContentsOfFile:moreAppsPlistPath];
	moreApps = [NSMutableArray array];
	for (NSString *name in moreAppNames) {
		MoreApp *app = [[MoreApp alloc]initWithName:name dictionary:moreAppsDict[name]];
		[moreApps addObject:app];
	}
}
- (void)loadView{
    self.view = [[UIView alloc]initWithFrame:_r];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadMoreApps];
    
    [self loadTopBar];
    
    
    tv = [[UITableView alloc]initWithFrame:CGRectMake(0, topBar.height + 5, _w, _h - topBar.height - 5) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    
//    tableTexts
    tableTexts = @[LString(@"Instruction"), LString(@"Rate Us"), LString(@"Support"),LString(@"Share on Facebook"),LString(@"Share on Twitter")];
    tableIconNames = @[@"Info_instruction.png",@"Info_rate.png",@"Info_email.png",@"Info_facebook.png",@"Info_twitter.png"];
    
    [self.view addSubview:topBar];
    [self.view addSubview:tv];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    L();
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	if (section == 0) {
   
        if (kVersion>= 6.0) {
            return 5;
        }
        else
            return 4;
	}
	else if(section == 1){

        return 1;
    }

	return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    //	return isPad?100:60;
    CGFloat height;
    int section = indexPath.section;
    if (section == 0) {
        height = 32*kIsPad2;
    }
    else{
        height = kHeightInfoMoreAppCell;
    }
	return height;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    int row = indexPath.row;
    UITableViewCell *cell;
	if (indexPath.section == 0) { //system
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

            cell.textLabel.font = [UIFont fontWithName:kFontName size:isPad?30:15];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = kColorLabelBlue;
            
        }

		cell.imageView.image = [UIImage imageNamed:tableIconNames[row]];
		cell.textLabel.text = tableTexts[row];
	}
    else if(indexPath.section == 1){
        cell = [[InfoMoreAppCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        InfoMoreAppCell *appCell = (InfoMoreAppCell*)cell;
        appCell.moreApps = moreApps;
        [appCell setInfoVC:self];
        
    }
 	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    int row = indexPath.row;
    switch (row) {
        case 0:
            [self toInstruction];
            break;
        case 1:
            [self rateUs];
            break;
        case 2:
            [self supportEmail];
            break;
        case 3:
            [self facebook];
            break;
        case 4:
            [self tweetus];
            break;
        default:
            break;
    }
	
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Instruction
- (void)instructionVCWillDismiss:(InstructionViewController *)vc{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [instructionVC.view setOrigin:CGPointMake(0, -_h)];
    } completion:^(BOOL finished) {
//
//        [instructionVC.view removeFromSuperview];
//        instructionVC = nil;
        [self performSelector:@selector(releaseInstruction) withObject:nil afterDelay:1]; 
    }];
}

- (void)releaseInstruction{
        [instructionVC.view removeFromSuperview];
        instructionVC = nil;

}
@end
