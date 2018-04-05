//
//  MyClaimsDetailsViewController.h
//  AMTrust
//
//  Created by kishore kumar on 01/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClaimDetailsTableViewCell.h"
@interface MyClaimsDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary *claimDetailDictionary;
}
@property (weak, nonatomic) IBOutlet UITableView *myClaimDetailsTableview;
@property (strong, nonatomic) NSString *claimId;

@end
