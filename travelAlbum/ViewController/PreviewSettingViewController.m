//
//  PreviewSettingViewController.m
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 19.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "PreviewSettingViewController.h"
#import "IpodMusicLibraryViewController.h"
#import "ChoiceTableViewController.h"

@interface PreviewSettingViewController ()

@end


@implementation PreviewSettingViewController

@synthesize vc, musicComp;


static NSString* const IconKeyPath = @"icon";
static NSString* const IconNeedsGlossEffectKeyPath = @"iconNeedsGlossEffect";
static NSString* const ChoiceTableViewIndexKeyPath = @"selectedIndex";

- (void)loadView{
	
	width = isPad?320:_w;
	height = 460;
	self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
	
	tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width, height) style:UITableViewStyleGrouped];
	tableView.dataSource = self;
	tableView.delegate = self;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"blackButtonBG.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:8 topCapHeight:0];

	startSlideB = [UIButton buttonWithFrame:CGRectMake(0, 0, width-20, 40) title:@"Start Slideshow" image:nil target:self action:@selector(buttonClicked:)];
	[startSlideB setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[startSlideB.titleLabel setFont:[UIFont boldSystemFontOfSize:[UIFont buttonFontSize]]];
	
	backBB = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonClicked:)];
	self.navigationItem.leftBarButtonItem = backBB;
	
	[self.view addSubview:tableView];
	
	tableKeys = @[@"Transition",@"Interval",@"Play Music", @"Music"];
	self.title = @"Slideshow Options";
	musicTitle = @"None";
	self.contentSizeForViewInPopover = CGSizeMake(width, height);
	tableValues = [NSMutableArray arrayWithArray:@[@"Dissolve",@3,@0,@"None"]];
	transitionKeys = @[@"Dissolve",@"Wipe",@"Slide"];

//    self.contentSizeForViewInPopover = CGSizeMake(self.view.width, self.view.height);
}


- (void)viewWillAppear:(BOOL)animated{
	L();
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidAppear:(BOOL)animated{
	L();
	[super viewDidAppear:animated];
		
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc{
	[transitionVC removeObserver:self forKeyPath:ChoiceTableViewIndexKeyPath context:nil];
}

#pragma mark - IBAction
- (IBAction)buttonClicked:(id)sender{
	if (sender == startSlideB) {

		[vc performSelector:@selector(updateSlideShow) withObject:nil afterDelay:1];
		
		[self back];
	}
	else if(sender == backBB){
		[self back];
	}
}

#pragma mark - Navigation
- (void)back{
	if (isPad) {
//		[[ViewController sharedInstance]dismissPopVC];
	}
	else{
		[[ICARootViewController sharedInstance]dismissModalViewControllerAnimated:YES];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

	if (section == 0) {
		return [tableKeys count];
	}
    else
		return 1;

}

/*
 
 Transition
 
 
 */


- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	int row = indexPath.row;
	int section = indexPath.section;
	
	
	// 只会调用一次，所以不用复用cell！
	
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
   
	if (indexPath.section == 0) {
		if(row == 0){
			cell.detailTextLabel.text = tableValues[row];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else if(row == 1){

			UISlider *slide = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
			[slide addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged];
			NSLog(@"vc.slideInterval # %f",vc.slideInterval);
			slide.value = (vc.slideInterval-kSlideIntervalMin)/(kSlideIntervalMax-kSlideIntervalMin);
			cell.accessoryView = slide;
		}
		else if (row == 2) { // Play music + uiswitch
			musicSwith = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
			[musicSwith addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
			musicSwith.on = musicPlaying;
			cell.accessoryView = musicSwith;
		}
		else if(row == 3){
			cell.detailTextLabel.text = musicTitle;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		cell.textLabel.text = [tableKeys objectAtIndex:row];
	}
	else if(section == 1){
		[cell.contentView addSubview:startSlideB];
		cell.backgroundView=[[UIView alloc] initWithFrame:cell.bounds];
	
	}
	
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

	int row = indexPath.row;
	int section = indexPath.section;
	
	if (section == 0 && row == 0) {
		// push to details tableview
		if (!transitionVC) {
			transitionVC = [[ChoiceTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
			transitionVC.tableKeys = transitionKeys;
			transitionVC.selectedIndex = 0;
			transitionVC.contentSizeForViewInPopover = self.view.frame.size;
			
			// transitionVC的值改变，self就得到消息
			[transitionVC addObserver:self forKeyPath:ChoiceTableViewIndexKeyPath options:NSKeyValueObservingOptionNew context:nil];
		}
		
		[self.navigationController pushViewController:transitionVC animated:YES];
	}
	else if(row == 3){

		if (!musicComp) {
			musicComp = [[IpodMusicLibraryViewController alloc]init];
			musicComp.view.alpha = 1;
//			musicComp.parent = self;
		}
		
		self.navigationController.navigationBarHidden = YES;
		[self.navigationController pushViewController:musicComp.picker animated:YES];


	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

#pragma mark - Switch Music play & off
- (void)switchChanged:(UISwitch*)sw{
	if (sw == musicSwith) {
		[musicComp playOrPauseMusic:nil];
		musicPlaying = musicSwith.on;
	}
}

// slide interval
- (void)slideValueChanged:(UISlider*)slide{
	NSLog(@"slide:%f",slide.value);
	vc.slideInterval = kSlideIntervalMin +  slide.value*(kSlideIntervalMax-kSlideIntervalMin);
	
}
- (void)didUsedMusic:(NSString*)_musicTitle{
	musicTitle = _musicTitle;
	musicPlaying = YES;
	[tableView reloadData];
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	L();
	id newObject = [change objectForKey:NSKeyValueChangeNewKey];
	if ([NSNull null] == (NSNull*)newObject)
		newObject = nil;
	
	NSLog(@"keypath:%@,newobj:%@",keyPath,newObject);
	
	if([keyPath isEqualToString:ChoiceTableViewIndexKeyPath]){

		int index = [newObject intValue];
		[tableValues replaceObjectAtIndex:0 withObject:transitionKeys[index]];
		NSLog(@"tablevalues:%@",tableValues);
		vc.slideType = index;
		[tableView reloadData];
	}
	
}
@end
