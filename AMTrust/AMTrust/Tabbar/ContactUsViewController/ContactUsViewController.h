//
//  ContactUsViewController.h
//  AMTrust
//
//  Created by kishore kumar on 23/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLExpandableTableView.h"
#import "ContactHeaderTableViewCell.h"
#import "ContactUsSectionTableViewCell.h"
#import "ContactHeaderCell.h"
#import "CommonRequest.h"
#import <MessageUI/MessageUI.h>

@interface ContactUsViewController : UIViewController<SLExpandableTableViewDelegate,SLExpandableTableViewDatasource,UITableViewDelegate,UITableViewDataSource,CommonRequestDelegate,MFMailComposeViewControllerDelegate>
{
    CommonRequest *commonRequest;
    NSArray *header,*details,*arrLoginHeader,*arrLoginDetails;
}
@property (weak, nonatomic) IBOutlet SLExpandableTableView *contactUsTableView;
@end
