//
//  MyPlansViewController.h
//  AMTrust
//
//  Created by kishore kumar on 31/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "MyPlansCollectionViewCell.h"
#import "CommonRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "PlanDetailViewController.h"

@protocol MyPlanDelegate <NSObject>
@required
-(void)myPlanRedirection:(NSDictionary *)selectedPlanDict withCategoryArray:(NSArray *)categoryArray;
-(void)showHomeScreen;
@end

@interface MyPlansViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,CommonRequestDelegate>
{
    NSMutableArray *myPlansArray;
    NSMutableArray *arrColorList;
    
    IBOutlet UICollectionView *collectionViewPlans;
}

@property( nonatomic, weak) id<MyPlanDelegate> delegate;

-(void)refresh;

@end
