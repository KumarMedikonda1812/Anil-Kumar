//
//  InviteFriendsViewController.h
//  AMTrust
//
//  Created by kishore kumar on 25/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "KBContactsSelectionViewController.h"
#import <APAddressBook/APContact.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import<CoreTelephony/CTTelephonyNetworkInfo.h>
#import<CoreTelephony/CTCarrier.h>
#import <Social/Social.h>

@interface InviteFriendsViewController : UIViewController<FBSDKAppInviteDialogDelegate, KBContactsSelectionViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    NSMutableArray *selectedContacts;
}
@property (weak, nonatomic) IBOutlet UILabel *lblBelow;

@end
