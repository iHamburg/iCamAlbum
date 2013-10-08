//
//  PreviewSettingViewController.h
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 19.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AlbumPreviewViewController.h"

#define kSlideIntervalMax 10
#define kSlideIntervalMin 2


@class IpodMusicLibraryViewController;
@class ChoiceTableViewController;
@interface PreviewSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
	UITableView *tableView;
	UISwitch *musicSwith;
	UIButton *startSlideB;
	UIBarButtonItem *backBB;
	IpodMusicLibraryViewController *musicComp;
	ChoiceTableViewController *transitionVC;
	
	NSArray *tableKeys;
	NSMutableArray *tableValues;
	NSArray *transitionKeys;
	
	NSString *musicTitle;
	CGFloat width,height;
	int transitionIndex;
	BOOL musicPlaying;
}

@property (nonatomic, unsafe_unretained) AlbumPreviewViewController *vc;
@property (nonatomic, strong) IpodMusicLibraryViewController *musicComp;

- (void)didUsedMusic:(NSString*)musicTitle;

@end
