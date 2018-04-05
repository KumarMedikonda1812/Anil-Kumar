//
//  WalkthroughViewController.h
//  AMTrust
//
//  Created by kishore kumar on 29/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelcomeViewController.h"
#import "WalkthroughCollectionViewCell.h"

@interface WalkthroughViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *contentArray;
    
    IBOutlet UIButton *backButton;
    
    IBOutlet UIPageControl *pageControl;
    IBOutlet UICollectionView *walkthroughCollectionView;
    IBOutlet UIButton *btnStart;
}

@property  BOOL showBackButton;
@property (strong, nonatomic)  NSString *originScreen;

@end
