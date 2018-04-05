//
//  HomeViewController.h
//  AMTrust
//
//  Created by kishore kumar on 23/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollTableViewCell.h"
#import "MenuTableViewCell.h"
#import "PlansTableViewCell.h"
#import "TipsForYouTableViewCell.h"
#import "DetailedHomeViewController.h"
#import "MenuSecondTableViewCell.h"
#import "PlanModel.h"
#import "PlanDetailViewController.h"
@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,TipDetailDelegate,CommonRequestDelegate>
{
    IBOutlet UITableView *homeTableView;
    
    NSMutableArray *arrTipsData,*arrAddTitleButtons;
    NSMutableArray *deviceCategoryArray;
    NSMutableArray *arrPlans;
    BOOL checkForScroll;
    PlanModel *selectedPlanModel;
    
}

@end
