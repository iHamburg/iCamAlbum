//
//  EditSidePageViewController.m
//  InstaMagazine
//
//  Created by AppDevelopper on 20.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "EditSidePageViewController.h"
#import "IAPManager.h"
#import "IAPItem.h"

@interface EditSidePageViewController ()

@end

@implementation EditSidePageViewController

@synthesize sidebar;

//- (MomentManager*)momentManager{
////    MomentManager *momentManager = sidebar.vc.momentManager;
//
//    return ni;
//}


- (void)loadView{

    [super loadView];
    
	manager = [AlbumManager sharedInstance];
	
	[self registerNotifications];
	
	self.view.backgroundColor = kColorDarkPattern;

	thumbSize = isPad?CGSizeMake(210, 140):CGSizeMake(130, 80);
	margin = isPad?20:14;
	
    selected = [[UIImageView alloc]initWithFrame:isPad?CGRectMake(0, 10, 250, 160):CGRectMake(0, 7, 160, 94)];
	selected.layer.cornerRadius = 10;
	gradientLayer = [CAGradientLayer layer];
	gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:155.0/255 green:196.0/255 blue:64.0/255 alpha:1].CGColor,(id)[UIColor colorWithRed:107.0/255 green:154.0/255 blue:50.0/255 alpha:1].CGColor,nil];
	gradientLayer.startPoint = CGPointMake(0,0);
	gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.frame = selected.bounds;
	[selected.layer addSublayer:gradientLayer];

	
    editBB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
    doneBB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleEditing)];
	addBB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonClicked:)];
    self.navigationItem.rightBarButtonItem = editBB;
	self.navigationItem.leftBarButtonItem = addBB;
	
	tv = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
	tv.delegate = self;
	tv.dataSource = self;
	tv.backgroundColor = [UIColor clearColor];
	tv.separatorStyle = UITableViewCellSeparatorStyleNone;

	[self.view addSubview:tv];
  
}





- (void)dealloc{

	L();
	
	[self unregisterNotifications];
	
}

- (void)setup{
	L();
	
	//predefined: album

	int num = self.momentManager.numberOfMoments;
	
	self.title = isPad?[NSString stringWithFormat:@"Pages (%d)",num]:@"Pages";
	
	[tv reloadData];
	
	UITableViewCell* cell = tv.visibleCells[0];
	NSIndexPath* path = [tv indexPathForCell:cell];
	UITableViewCell *lastCell = [tv.visibleCells lastObject];
	NSIndexPath* lastPath = [tv indexPathForCell:lastCell];

    int momentIndex = self.momentManager.currentMomentIndex;
	if (momentIndex < path.row ||momentIndex > lastPath.row) {
		[tv scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:momentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		
	}

}


#pragma mark - IBAction

- (void)toggleEditing{

    if (!tv.editing) {
        self.navigationItem.rightBarButtonItem = doneBB;
    }
    else{
        self.navigationItem.rightBarButtonItem = editBB;
    }
    
    tv.editing = !tv.editing;
}

- (void)buttonClicked:(id)sender{
	if (sender == addBB) {

		[self addPage];
	}
}
#pragma mark - Observer
- (void)registerNotifications{
	
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePage) name:NotificationCurrentMomentIndexChanged object:nil];
}

- (void)unregisterNotifications{
	
//	[album removeObserver:self forKeyPath:kKeyPathMomentIndex context:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	L();
	id newObject = [change objectForKey:NSKeyValueChangeNewKey];
	if ([NSNull null] == (NSNull*)newObject)
		newObject = nil;
    
//	NSLog(@"keypath:%@,newobj:%@",keyPath,newObject);
    
	// 当editVC改变momentindex的时候刷新tableview
	if([keyPath isEqualToString:kKeyPathMomentIndex]){

		[self setup];
	}

    
	
}

#pragma mark - Tableview


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    int  num = self.momentManager.numberOfMoments;

	return num;
    
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return thumbSize.height+margin;
}

// momentThumb.size: 210x140

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    int row = [indexPath row];
	int section = indexPath.section;
    static NSString *CellIdentifier = @"Cell";
	
	
    UIImageView *imgV;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       imgV = [[UIImageView alloc]initWithFrame:CGRectMake(margin, margin, thumbSize.width, thumbSize.height)];
		imgV.layer.cornerRadius = round(0.05*thumbSize.height);
        imgV.tag = 123;
		imgV.layer.borderColor = [UIColor darkGrayColor].CGColor;
		imgV.layer.masksToBounds = YES;
        [cell.contentView addSubview:imgV];
	}
    else{
        imgV = (UIImageView*)[cell.contentView viewWithTag:123];
    }
    
   
    if (section == 0) {
        Moment *moment = [self.momentManager momentAtIndex:row];
        NSString *thumbName = [moment previewImgName];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *image = [UIImage imageWithSystemName:thumbName];
		image = [image imageByScalingAndCroppingForSize:thumbSize];
		imgV.image = image;
		int currentIndex = self.momentManager.currentMomentIndex;

        if (currentIndex == row) {

			[cell.contentView insertSubview:selected belowSubview:imgV];
        }
		else{
			if ([cell.contentView.subviews containsObject:selected]) {
				[selected removeFromSuperview];
			}
		}
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
	
	
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
	 // 如果tableview在editing状态下，可以编辑
	 return tableView.editing ;
 }



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
	 if (editingStyle == UITableViewCellEditingStyleDelete) {
	 // Delete the row from the data source
		 
		  [self deletePage:indexPath.row];
		 
		 NSLog(@"after delete page");
		 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

		
     }
     else if (editingStyle == UITableViewCellEditingStyleInsert) {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }

 }



 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {

     L();
     NSLog(@"move from:%d, to %d",fromIndexPath.row,toIndexPath.row);
     int fromIndex = fromIndexPath.row;
     int toIndex = toIndexPath.row;

	 [self movePage:fromIndex toPage:toIndex];
 }



 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
     if (indexPath.section == 0) {
         return YES;
     }
     return NO;
 }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	int section = indexPath.section;
    int row = indexPath.row;
    if (section == 0) {

        self.momentManager.currentMomentIndex = row;

    }

		
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Page Functions

//加在最后，不改变当前moment, 需要更新editVC的pagecontrol
- (void)addPage{
	
	[self.momentManager addMoment]; // 不能用 _currentAlbum
	
	[self updatePage];


}

//  如果index是当前page，就跳到首页; 如果是album只有一页，不能删除
- (void)deletePage:(int)index{

//	L();
	if (self.momentManager.numberOfMoments==1) {
		return;
	}
    [self.momentManager deleteMomentAtIndex:index];
    
    if (self.momentManager.currentMomentIndex == index) {
        self.momentManager.currentMomentIndex = 0;
    }
//	
//	if (index == album.momentIndex) {
//		album.momentIndex = 0;
//	}

//	[manager deleteMoment:index];
}

- (void)updatePage{
	L();
	
	//tableview scroll to currentmomentindex, iphone没有pagecontrol，所以不需要自动scroll！，ipad好像也没有
	
	//如果不在编辑状态就setup, 如果在编辑状态删除的page，就不要自动reloaddata！
	if (!tv.editing) {
		[self setup];	
	}

}


/*
 @[@0,@1,@2,@3,@4,@5,@6]
 
 from 4->1
 
 0,4,1,2,3,5,6
 
 from 1->4
 
 0,2,3,4,1,5,6
 
 */
- (void)movePage:(int)indexA toPage:(int)indexB{
	// move 4 to 1

//	[album moveMomentFrom:indexA to:indexB];
    [self.momentManager moveMomentFrom:indexA to:indexB];
	
//	int currentIndex = album.momentIndex;
    int currentIndex = self.momentManager.currentMomentIndex;
	
    if (indexA>indexB) { //4->1
		//1-3 ,+1
		if (currentIndex>=indexB && currentIndex<indexA) { // 如果currentIndex 在from和to之间，+1
//			album.momentIndex++;
            self.momentManager.currentMomentIndex ++;
		}
		else if(currentIndex == indexA){ // 如果currentIndex就是from，currentindex-》toIndex
//			album.momentIndex = indexB;
            self.momentManager.currentMomentIndex = indexB;
		}
	}
	else{ //1->4
		//2-4,-1
		if (currentIndex>indexA && currentIndex<=indexB) {
//			album.momentIndex--;
            self.momentManager.currentMomentIndex --;
		}
		else if(currentIndex == indexA){
//			album.momentIndex = indexB;
            self.momentManager.currentMomentIndex = indexB;
		}
	}
}
@end
