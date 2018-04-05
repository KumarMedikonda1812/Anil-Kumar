//
//  MyClaimsViewController.h
//  AMTrust
//
//  Created by kishore kumar on 31/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClaimsTableViewCell.h"
#import "MyClaimsDetailsViewController.h"
#import "WebViewController.h"

@protocol MyClaimDelegate <NSObject>
@required
    -(void)redirectToClaimDetails:(NSString *)claimID;
@end


@interface MyClaimsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrClaimDetails;
}
@property (weak, nonatomic) IBOutlet UIButton *btnClaimNow;
@property (weak, nonatomic) IBOutlet UITableView *myClaimsTableView;
@property( nonatomic, weak) id<MyClaimDelegate> delegate;

- (IBAction)ActionClaimNow:(id)sender;

@end
