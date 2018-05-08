//
//  ContactUsViewController.m
//  AMTrust
//
//  Created by kishore kumar on 23/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController
@synthesize contactUsTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [contactUsTableView registerNib:[UINib nibWithNibName:@"ContactHeaderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ContactHeaderTableViewCell"];
    [contactUsTableView registerNib:[UINib nibWithNibName:@"ContactUsSectionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ContactUsSectionTableViewCell"];
    [contactUsTableView registerNib:[UINib nibWithNibName:@"ContactHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ContactHeaderCell"];
    
    header = @[@"What is TecProtec?",@"What devices can be protected?",@"How much are the subscription fees for TecProtec protection?",@"Where can I find details of my plan?",@"When does my plan expire?",@"How can I edit my profile photo?",@"How do I make a claim?",@"How do I check the status of my claim?",@"How can I speak with someone?"];
    
    arrLoginHeader = @[@"Where can I find details of my plan?",@"When does my plan expire?",@"How can I edit my profile photo?",@"How do I make a claim?",@"How do I check the status of my claim?",@"How can I speak with someone?",@"I want to speak to someone"];
    
    arrLoginDetails = @[@"Simply tap the Profile button. Under My Plans, tap the plan you wish to know more about. All the details will be inside this screen. You need to be logged in to your account to see your plans.",@"You can see the exact expiry date of your plan by tapping the Profile button. Under My Plans, tap the plan that you want to check and it will show you expiry date and more. You need to be logged in to your account to see your plans.",@"Tap the Profile button then click Edit Profile under the photo icon or your current photo. In the Edit Profile section, tap the camera icon, choose the source of your photo then pick your new photo. Tap ‘Save’ and your photo will be updated.",@"Tap the Profile button then select the plan that you want to make a claim for. Inside the plan, tap ‘Submit Claim’ and follow the steps.",@"Tap the Profile button then tap ‘My Claims’. Inside this screen, you will see the plan and its status.",@"For our customers in Indonesia, you may call  0804-1401-078 or send an email to cs@amtrustmobilesolutions.co.id."];
    
    details = @[@"TecProtec provides membership plans that offer protection for your gadgets to ensure that you have an uninterrupted digital life. With TecProtec, your gadget gets protection for theft, accidental damage and liquid damage. You no longer need to worry about hefty repair costs or buying a new phone.",@"TecProtec provides protection for various gadgets that you can see under the ‘Home’ tab such as smartphone and tablet.",@"Subscription fees depend on the value of your gadget. You can check the exact value by going to the Home tab > pick a gadget to protect > key-in the value of your gadget and when you bought your gadget > pick payment between monthly and annual then you’ll see the exact subscription fee.",@"Simply tap the Profile button. Under My Plans, tap the plan you wish to know more about. All the details will be inside this screen. You need to be logged in to your account to see your plans.",@"You can see the exact expiry date of your plan by tapping the Profile button. Under My Plans, tap the plan that you want to check and it will show you expiry date and more. You need to be logged in to your account to see your plans.",@"Tap the Profile button then click Edit Profile under the photo icon or your current photo. In the Edit Profile section, tap the camera icon, choose the source of your photo then pick your new photo. Tap ‘Save’ and your photo will be updated.",@"Tap the Profile button then select the plan that you want to make a claim for. Inside the plan, tap ‘Submit Claim’ and follow the steps.",@"Tap the Profile button then tap ‘My Claims’. Inside this screen, you will see the plan and its status.",@"For our customers in Indonesia, you may call  0804-1401-078 or send an email to cs@amtrustmobilesolutions.co.id"];
    
    
    commonRequest = [CommonRequest sharedInstance];
    commonRequest.delegate = self;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Help", nil, [[Helper sharedInstance] getLocalBundle], nil);

    [[Helper sharedInstance] trackingScreen:@"Help_IOS"];

}

#pragma mark - Common Request Delegate
- (void)commonRequestGetResponse:(NSDictionary *)response withAPIName:(NSString *)name {
    NSLog(@"tips details = %@",response);
}

#pragma mark slexpandableTableview datasource
- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section
{
    if(section==0)
        return NO;
    else
        return YES;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section
{
    return NO;
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
{
    // this cell will be displayed at IndexPath with section: section and row 0
    ContactHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactHeaderTableViewCell"];
    if(!cell)
    {
        cell = [[ContactHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactHeaderTableViewCell"];
    }
    if([[Helper sharedInstance] isLogin])
    {
        cell.lblQuestions.text = NSLocalizedStringFromTableInBundle([arrLoginHeader objectAtIndex:section-1], nil, [[Helper sharedInstance] getLocalBundle], nil);
        
    }
    else
    {
        if(section!=0)
        {
            cell.lblQuestions.text = NSLocalizedStringFromTableInBundle([header objectAtIndex:section-1], nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
    }
    return cell;
    
}
#pragma mark slexpandableTableview delegate
- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
    // download your data here
    // call [tableView expandSection:section animated:YES]; if download was successful
    // call [tableView cancelDownloadInSection:section]; if your download was NOT successful
}

- (void)tableView:(SLExpandableTableView *)tableView didExpandSection:(NSUInteger)section animated:(BOOL)animated
{
    ContactHeaderTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    cell.imgExpandColapse.image = [UIImage imageNamed:@"subtract"];
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
{
    ContactHeaderTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    cell.imgExpandColapse.image = [UIImage imageNamed:@"add"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 1;
    else
        return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([[Helper sharedInstance] isLogin])
    {
        return arrLoginDetails.count+1;
    }
    else
    {
        return details.count+1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0)
    {
        ContactHeaderCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:@"ContactHeaderCell"];
        if(!cellHeader)
        {
            cellHeader = [[ContactHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactHeaderCell"];
        }
        return cellHeader;
    }
    else
    {
        ContactUsSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactUsSectionTableViewCell"];
        if(!cell)
        {
            cell = [[ContactUsSectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactUsSectionTableViewCell"];
        }
        if([[Helper sharedInstance] isLogin])
        {
           // cell.textVieWdetails.text = NSLocalizedStringFromTableInBundle([arrLoginDetails objectAtIndex:indexPath.section-1], nil, [[Helper sharedInstance] getLocalBundle], nil);
            cell.textVieWdetails.text = NSLocalizedStringFromTableInBundle([arrLoginDetails objectAtIndex:indexPath.section-1], nil, [[Helper sharedInstance] getLocalBundle], nil);


        }
        else
        {
           // cell.textLabel.text = NSLocalizedStringFromTableInBundle([details objectAtIndex:indexPath.section-1], nil, [[Helper sharedInstance] getLocalBundle], nil);
            cell.textVieWdetails.text = NSLocalizedStringFromTableInBundle([details objectAtIndex:indexPath.section-1], nil, [[Helper sharedInstance] getLocalBundle], nil);

        }
        
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld row =%ld",(long)indexPath.section,(long)indexPath.row);
    if(indexPath.section==6)
    {
        if([[Helper sharedInstance] isLogin])
        {
            if ([MFMailComposeViewController canSendMail]) {
                
                NSArray *toRecipents = [NSArray arrayWithObject:@"cs@amtrustmobilesolutions.co.id"];
                
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                mc.mailComposeDelegate = self;
                [mc setSubject:@"Regarding "];
                [mc setToRecipients:toRecipents];
                
                // Present mail view controller on screen
                [self presentViewController:mc animated:YES completion:NULL];
                
            }
            else
            {
                [Helper popUpMessage:@"Please setup gmail account" titleForPopUp:@"" view:self.view];
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"mailto:test@test.com"]];
                
            }

        }
    }
    else if (indexPath.section==9)
    {
        if(![[Helper sharedInstance] isLogin])
        {
            if ([MFMailComposeViewController canSendMail]) {
                
                NSArray *toRecipents = [NSArray arrayWithObject:@"cs@amtrustmobilesolutions.co.id"];
                
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                mc.mailComposeDelegate = self;
                [mc setSubject:@"Regarding "];
                [mc setToRecipients:toRecipents];
                
                // Present mail view controller on screen
                [self presentViewController:mc animated:YES completion:NULL];
                
            }
            else
            {
                [Helper popUpMessage:@"Please setup gmail account" titleForPopUp:@"" view:self.view];
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"mailto:test@test.com"]];
                
            }
            
        }

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 300;
    }
    else
    {
        if(indexPath.row == 0)
            return 50;
        else
            return 130;
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
