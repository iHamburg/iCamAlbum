    //
//  AlbumCover.m
//  Everalbum
//
//  Created by AppDevelopper on 13-8-22.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "AlbumCover.h"
#import "PaddingLabel.h"

@implementation AlbumCover

@synthesize album,managerVC;

- (void)setAlbum:(Album *)album_{
    album = album_;
    
    innenPhotoImgV.image = [album.coverPhotoImage imageByScalingAndCroppingForSize:innenPhotoImgV.bounds.size];
  
    coverIndicatorV.text = [NSString stringWithInt:album.numberOfMoments];
    titleL.text = album.title;
    
    if (album.isIconBarOpened) {

        [self openIconBarCover];
    }
    else{
        [self closeIconBarCover];
    }
    
    if (album.loved) {
        [loveB setImage:[UIImage imageNamed:@"icon_albumCover_liked2.png"] forState:UIControlStateNormal];
    }
    else{
         [loveB setImage:[UIImage imageNamed:@"icon_albumCover_like2.png"] forState:UIControlStateNormal];
    }
    
    if (album.locked) {
        [lockB setImage:[UIImage imageNamed:@"icon_albumCover_lock.png"] forState:UIControlStateNormal];
        NSLog(@"album.password # %@",album.password);
    }
    else{
        [lockB setImage:[UIImage imageNamed:@"icon_albumCover_unlock.png"] forState:UIControlStateNormal];
    }
    
    if (album.photoPreviewImage) {
        [photoPreviewB setImage:album.photoPreviewImage forState:UIControlStateNormal];

    }
    else{
        [photoPreviewB setImage:album.photoPreviewImage forState:UIControlStateNormal];

    }

    dateL.text = album.createdDatum;
    
//    pwLabel.text = album.title;
}

/// default: iconBarCover is closed!
- (void)loadIconBar{
    
    iconBarContainer = [[UIView alloc]initWithFrame:CGRectMake(isPad?50:15, CGRectGetMaxY(innenPhotoImgV.frame)+(isPad?10:5), 210*kIsPad2, self.height - CGRectGetMaxY(innenPhotoImgV.frame))];
    iconBarContainer.center = CGPointMake(self.width/2, self.height - iconBarContainer.height/2 - 1);
    iconBarContainer.layer.masksToBounds = YES;
    
    iconBar = [[UIView alloc] initWithFrame:iconBarContainer.bounds];
    [iconBar setBGView:@"Album_iconCover.png"];
    
    CGFloat wB = isPad?52:30;
    SEL buttonSel = @selector(buttonClicked:);
    
//    openB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"AlbumCover_blau_point.png" target:self action:buttonSel];
    shareB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_albumCover_share.png" target:self action:buttonSel];
    loveB =  [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"AlbumCover_like.png" target:self action:buttonSel];
    playB =  [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_albumCover_changeCover.png" target:self action:buttonSel];
//     playB =  [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:kPlaceholderIconName target:self action:buttonSel];
    lockB =  [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_albumCover_lock.png" target:self action:buttonSel];
    deleteB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_albumCover_trash.png" target:self action:buttonSel];
  
    NSArray *buttons = @[shareB,loveB,playB,lockB, deleteB];
    CGFloat offset = (iconBar.width - wB)/(buttons.count - 1) - 3;
    for (int i = 0 ; i< [buttons count]; i++) {
        UIButton *b = buttons[i];
//        [b setBackgroundImage:[UIImage imageNamed:@"AlbumCoverIconBG2.png"] forState:UIControlStateNormal];
        b.autoresizingMask = kAutoResize;
        b.center = CGPointMake(5 + wB/2 + i * offset, iconBar.height/2);
        [iconBar addSubview:b];
        
    }
    iconBar.alpha = 0;
    
    [iconBarContainer addSubview:iconBar];
    
    
    _shareButtonRect = [iconBar convertRect:shareB.frame toView:self];

//    iconBar.backgroundColor = [UIColor redColor];
}


- (void)addGestureRecognizer{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    if (kVersion<6.0) {
     
        tap.cancelsTouchesInView = NO;
    }
    
    [self addGestureRecognizer:tap];
//
}
- (void)loadCameraB
{
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        cameraB = [UIButton buttonWithFrame:CGRectMake(0, 0, isPad?48:48, isPad?40:34) title:nil imageName:@"AlbumCover_Camera.png" target:self action:@selector(buttonClicked:)];
        cameraB.center = CGPointMake(self.width - cameraB.width/2 - (isPad?20:5), cameraB.height/2 + (isPad?10:5));

        
        photoPreviewB = [UIButton buttonWithFrame:CGRectMake(isPad?15:5, isPad?12:5, kwPhotoPreviewImage, 0.8*kwPhotoPreviewImage) title:nil imageName:nil target:self action:@selector(buttonClicked:)];
        
        photoPreviewB.layer.borderWidth = 1;
        photoPreviewB.layer.borderColor = [UIColor whiteColor].CGColor;
        
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        
        UIImageView *bgV = [[UIImageView alloc]initWithFrame:self.bounds];
        bgV.image = [UIImage imageNamed:@"Home_AlbumCoverBG.png"];
        bgV.autoresizingMask = kAutoResize;
        [self addSubview:bgV];
        
        coverIndicatorV = [[IndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32*kIsPad2, 24*kIsPad2)];
        coverIndicatorV.center = CGPointMake(self.width, 0);
        coverIndicatorV.autoresizingMask = kAutoResize;
        coverIndicatorV.image = [UIImage imageNamed:@"Home_pageNumber.png"];
        
        CGFloat xPhotoMargin = isPad?2:2;
        innenPhotoImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width - 2*xPhotoMargin, 140*kIsPad2)];
        innenPhotoImgV.image = kPlaceholderImage;
        innenPhotoImgV.center = CGPointMake(self.width/2, self.height/2);
        innenPhotoImgV.autoresizingMask = kAutoResize;
        innenPhotoImgV.userInteractionEnabled = YES;
//        innenPhotoImgV.alpha = .6;
        
        [innenPhotoImgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];

        
        titleL = [[PaddingLabel alloc]initWithFrame:CGRectMake(0, 0.75*innenPhotoImgV.height, 0.75*innenPhotoImgV.width, 0.25*innenPhotoImgV.height)];
        titleL.backgroundColor = [UIColor colorWithWhite:0 alpha:0.86];
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.font = [UIFont fontWithName:kFontName size:isPad?30:16];
        titleL.textColor  = [UIColor whiteColor];
        titleL.userInteractionEnabled = YES;
        [titleL addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
        

        dateL = [[PaddingLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleL.frame), CGRectGetMinY(titleL.frame), innenPhotoImgV.width - CGRectGetMaxX(titleL.frame), titleL.height)];
        dateL.backgroundColor = [UIColor colorWithWhite:0 alpha:0.86];
        dateL.font = [UIFont fontWithName:kFontName size:isPad?18:12];
        dateL.textColor = [UIColor whiteColor];
        dateL.textAlignment = NSTextAlignmentRight;
        dateL.text = @"13-02-13";
        
        [innenPhotoImgV addSubview:titleL];
        [innenPhotoImgV addSubview:dateL];

        CGFloat wB =  isPad?50:30;
        openB = [UIButton buttonWithFrame:CGRectMake(self.width - wB - (isPad?20:9), self.height - wB - 6,wB,wB) title:nil imageName:@"icon_AlbumPower.png" target:self action:@selector(buttonClicked:)];
        
        /// for managerVC save album coverphotoimage
        _coverPhotoSize = CGSizeMake(innenPhotoImgV.width, innenPhotoImgV.height);
        
        
//        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
        
        [self addGestureRecognizer];
        
        
        [self loadIconBar];
        [self loadCameraB];
        
        
     
        [self addSubview:cameraB];
        [self addSubview:photoPreviewB];
        [self addSubview:coverIndicatorV];
        [self addSubview:iconBarContainer];
        [self addSubview:innenPhotoImgV];
        [self addSubview:openB];
        
//        self.layer.masksToBounds = YES;
//        self.backgroundColor = [UIColor blackColor];
        
//        pwLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200,50)];
//        [self addSubview:pwLabel];
//        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)dealloc
{
//    L();
}
#pragma mark - IBAction


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}
- (void)buttonClicked:(UIButton*)sender{
    
    [sender rotate];
    
    if (sender == shareB) {
        [managerVC popShareAlbumView:sender];
    }
    else if(sender == loveB){
  
        [managerVC toggleLoveAlbum:sender];
        
    }
    else if (sender == playB){

        [managerVC changeCoverImage:sender];
    }
    else if (sender == lockB){
        [managerVC toggleLockAlbum:sender];
    }
    else if(sender == deleteB){
        [managerVC deleteAlbum:sender];
    }
    else if(sender == cameraB){
        [managerVC openCamera:sender];

    }
    else if(sender == openB){
        [self toggleOpenIconBar:sender];
    }
    else if(sender == photoPreviewB){
//        [managerVC editAlbum:sender];
//        [managerVC previewAlbum:nil];
        [managerVC toEditAlbum:nil];
    }
}

- (IBAction)handleTap:(UITapGestureRecognizer*)sender{
    L();
    UIView * v = sender.view;
    CGPoint point = [sender locationInView:v];
//    NSLog(@"v # %@",v);
//    CGPoint point = [sender locationInView:v];
    NSLog(@"iconbar # %@, point # %@",NSStringFromCGRect(iconBarContainer.frame),NSStringFromCGPoint(point));
    
    if (v == innenPhotoImgV) {

        [managerVC previewAlbum:sender];

    }
    else if(v == titleL){
        [managerVC changeTitle:v];
    }
    else if(!CGRectContainsPoint(iconBarContainer.frame, point)){
        ///避免点到icon button ，误入preivew！
         [managerVC previewAlbum:sender];
    }
}

- (IBAction)toggleOpenIconBar:(id)sender{
    if (album.isIconBarOpened) {
        [self closeIconBarCover];
    }
    else{
        [self openIconBarCover];
    }
}

#pragma mark -

- (void)openIconBarCover{
    [UIView animateWithDuration:0.4 animations:^{

        iconBar.alpha = 1;
    
    }];

    album.isIconBarOpened = YES;

}
- (void)closeIconBarCover{
    [UIView animateWithDuration:0.4 animations:^{

        iconBar.alpha = 0;
    }];
 

    album.isIconBarOpened = NO;
}

#pragma mark = Intern Fcn
//
//- (void)rotate:(UIView*)v{
// 
//  
//    
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 1 ];
//    rotationAnimation.duration = 0.4;
//    rotationAnimation.cumulative = YES;
////    rotationAnimation.repeatCount = repeat;
////	
////    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
////    scaleAnimation.toValue = [NSNumber numberWithFloat:1.1];
////    scaleAnimation.duration = duration/2;
////    scaleAnimation.autoreverses = YES;
////    scaleAnimation.repeatCount = 1;
////    
////    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
////    group.animations = [NSArray arrayWithObjects:rotationAnimation,scaleAnimation, nil];
////    
////    //这里的时间一定要加，否则group的时间不对
////    group.duration = duration;
//    
////    [view.layer addAnimation:group forKey:@"group"];
//    
//    [v.layer addAnimation:rotationAnimation forKey:@"rotation"];
//}
@end
