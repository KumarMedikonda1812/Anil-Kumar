//
//  InviteFriendsViewController.m
//  AMTrust
//
//  Created by kishore kumar on 25/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "InviteFriendsViewController.h"


@interface InviteFriendsViewController ()
@property (weak) KBContactsSelectionViewController* presentedCSVC;

@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedContacts = [[NSMutableArray alloc] init];
    
    self.title = NSLocalizedStringFromTableInBundle(@"Invite Friends", nil, [[Helper sharedInstance] getLocalBundle], nil);
    //Protect your gadgets against accidental damage, liquid damage and theft with the TecProtec app. It’s fast and easy! Download here https://itunes.apple.com/us/app/tecprotec/id1246749763?ls=1&mt=8
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    backButton.tintColor = [Helper colorWithHexString:@"FF304B"];
                                   
    self.navigationItem.leftBarButtonItem = backButton;
    
    _lblBelow.text = NSLocalizedStringFromTableInBundle(@"Share to your friends", nil, [[Helper sharedInstance] getLocalBundle], nil);

    [[Helper sharedInstance] trackingScreen:@"InviteFriends_ios"];

}


- (IBAction)actionSMS:(id)sender {
    
    if([self checkForSIMCard])
    {
        __block KBContactsSelectionViewController *vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:^(KBContactsSelectionConfiguration *configuration) {
            configuration.shouldShowNavigationBar = YES;
            configuration.tintColor = THEMECOLOR
            configuration.title = @"Send SMS";
            configuration.selectButtonTitle = @"Save";
            
            configuration.mode = KBContactsSelectionModeMessages;
            configuration.skipUnnamedContacts = YES;
            configuration.customSelectButtonHandler = ^(NSArray * contacts) {
                NSLog(@"This is printing %@", contacts);
                
            };
            configuration.contactEnabledValidation = ^(id contact) {
                APContact * _c = contact;
                if ([_c phones].count > 0) {
                    NSString * phone = ((APPhone*) _c.phones[0]).number;
                    if ([phone containsString:@"888"]) {
                        return NO;
                    }
                }
                
                if([[_c name].firstName isEqualToString:@""] && [[_c name].lastName isEqualToString:@""]){
                    return NO;
                }
                
                return YES;
            };
        }];
        [vc setDelegate:self];
        
        [self.navigationController pushViewController:vc animated:YES];
        self.presentedCSVC = vc;
        
        __block UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 24)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Select people you want to invite";
        
        vc.additionalInfoView = label;
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
        backButton.tintColor = [Helper colorWithHexString:@"FF304B"];
        
        vc.navigationItem.leftBarButtonItem = backButton;
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedStringFromTableInBundle(@"Send", nil, [[Helper sharedInstance] getLocalBundle], nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
        
        rightButton.tintColor = [Helper colorWithHexString:@"#FF304B"];
        
        vc.navigationItem.rightBarButtonItem = rightButton;
    }else
    {
        [Helper popUpMessage:@"Looks like you do not have SIM card in this phone. This feature requires a SIM card to work" titleForPopUp:@"SIM Card Missing" view:[UIView new]];
    }
}

-(IBAction)saveAction:(id)sender
{
    NSLog(@"selectedContacts count = %lu",(unsigned long)[selectedContacts count]);
    
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    
    for(int i=0;i<[selectedContacts count];i++)
    {
        APContact *contact = [selectedContacts objectAtIndex:i];
        [phoneNumbers addObject:contact.phones[0].number];
    }
    
    NSString *text = NSLocalizedStringFromTableInBundle(@"Protect your gadgets against accidental damage, liquid damage and theft with the TecProtec app. It’s fast and easy! Download here http://onelink.to/zyku3p", nil, [[Helper sharedInstance] getLocalBundle], nil);
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:phoneNumbers];
    [messageController setBody:text];
    
    [self.presentedCSVC presentViewController:messageController animated:YES completion:nil];
}

-(IBAction)whatsApp:(id)sender
{
    NSString *text = NSLocalizedStringFromTableInBundle(@"Protect your gadgets against accidental damage, liquid damage and theft with the TecProtec app. It’s fast and easy! Download here http://onelink.to/zyku3p", nil, [[Helper sharedInstance] getLocalBundle], nil);
    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
    NSString *result = [text stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString *strText = [NSString stringWithFormat:@"whatsapp://send?text=%@",result];
    
    NSURL * whatsappURL = [NSURL URLWithString:strText];

    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else
    {
        [Helper popUpMessage:@"Please install whatsapp" titleForPopUp:@"Whatsapp is missing" view:self.view];
    }
}


-(IBAction)ActionFb:(id)sender
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL =  [NSURL URLWithString:@"https://admin.tecprotec.co/share"];
    
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = self;
    dialog.shareContent = content;
    dialog.mode = FBSDKShareDialogModeNative;
    [dialog show];
}

-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    
}

-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    
}

#pragma mark - KBContactsSelectionViewControllerDelegate
- (void) contactsSelection:(KBContactsSelectionViewController*)selection didSelectContact:(APContact *)contact {
    
    __block UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 36)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%@ Selected", @(self.presentedCSVC.selectedContacts.count)];
    
    self.presentedCSVC.additionalInfoView = label;
    
    selectedContacts = [self.presentedCSVC.selectedContacts mutableCopy];

    NSLog(@"%@", self.presentedCSVC.selectedContacts);
}

- (void) contactsSelection:(KBContactsSelectionViewController*)selection didRemoveContact:(APContact *)contact {
    
    __block UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 36)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%@ Selected", @(self.presentedCSVC.selectedContacts.count)];
    
    self.presentedCSVC.additionalInfoView = label;
    
    selectedContacts = [self.presentedCSVC.selectedContacts mutableCopy];

    NSLog(@"%@", self.presentedCSVC.selectedContacts);
}

- (void)contactsSelectionWillLoadContacts:(KBContactsSelectionViewController *)csvc
{
    [SVProgressHUD showWithStatus:@"Loading..."];
}

- (void)contactsSelectionDidLoadContacts:(KBContactsSelectionViewController *)csvc
{
    [SVProgressHUD dismiss];
}

#pragma mark - messageComposeViewController Delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    if (result == MessageComposeResultCancelled)
    {
        NSLog(@"Message cancelled");
        
    }else if (result == MessageComposeResultSent)
    {
        [Helper popUpMessage:@"Message successfully sent." titleForPopUp:@"" view:[UIView new]];
    }else
    {
        [Helper popUpMessage:@"Message sending failed." titleForPopUp:@"" view:[UIView new]];
    }
}

-(BOOL)checkForSIMCard
{
    BOOL isSimCardAvailable = YES;
    
    CTTelephonyNetworkInfo* info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier* carrier = info.subscriberCellularProvider;
    
    if(carrier.mobileNetworkCode == nil || [carrier.mobileNetworkCode isEqualToString:@""])
    {
        isSimCardAvailable = NO;
    }
    
    return isSimCardAvailable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
