//
//  MyActivitiesViewController.h
//  AMTrust
//
//  Created by kishore kumar on 31/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyActivitiesTableViewCell.h"
#import "NSString_stripHtml.h"

@interface MyActivitiesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrActivityTips;
}
@property (weak, nonatomic) IBOutlet UITableView *myActivitiesTableView;

@end
