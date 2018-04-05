//
//  NotificationViewController.h
//  TecProtec
//
//  Created by kishore kumar on 18/09/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonRequest.h"
#import "PlanDetailViewController.h"
@interface NotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CommonRequestDelegate>
{
    NSArray *arrResult;
    CommonRequest *commonRequest;
    NSString *policyId;
}
@property (weak, nonatomic) IBOutlet UITableView *notificationTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationText;
@end
