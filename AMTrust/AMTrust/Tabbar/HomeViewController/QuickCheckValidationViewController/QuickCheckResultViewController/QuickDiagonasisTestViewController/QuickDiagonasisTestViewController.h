//
//  QuickDiagonasisTestViewController.h
//  Tecprotec
//
//  Created by kishore kumar on 09/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <MediaPlayer/MPVolumeView.h>
#import "TestCollectionViewCell.h"
#import "QuickCheckResultViewController.h"
#import "TouchViewController.h"
#import "MuteChecker.h"

@interface QuickDiagonasisTestViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TouchDelegate>
{
    BOOL volumeTestBool,screenShotBool,frontCamera,backCamera,screenBool,screenCheckBool,muteBool,volumeIncrease,volumeDecrease,tecExpert,screenTestDelegateBool;
    NSInteger number;
    NSInteger cameraSplit;
    UIImage *imgScreen;
    CGFloat currentVolume;
    UIImagePickerController *imagePicker;
    
}
@property (nonatomic, strong) MuteChecker *muteChecker;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet UICollectionView *textCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end
