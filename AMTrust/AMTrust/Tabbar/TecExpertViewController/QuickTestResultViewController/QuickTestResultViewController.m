//
//  QuickTestResultViewController.m
//  Tecprotec
//
//  Created by kishore kumar on 16/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "QuickTestResultViewController.h"

@interface QuickTestResultViewController ()

@end

@implementation QuickTestResultViewController

@synthesize deviceSummaryTableView;
@synthesize volumeBool,muteBool,frontCamBool,rearCamBool,screenTestBool,wifiBool,dataConnectionBool,batteryBool,gyroBool,bluetoothBool,gpsBool,screenShotBool;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [deviceSummaryTableView registerNib:[UINib nibWithNibName:@"QuickCheckResultTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QuickCheckResultTableViewCell"];
    
    gyroBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"gyro"] boolValue];
    batteryBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"battery"] boolValue];
    gpsBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"gps"] boolValue];
    bluetoothBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bluetooth"] boolValue];
    dataConnectionBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"dataConnection"] boolValue];
    wifiBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"wifi"] boolValue];
    frontCamBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"frontCamera"] boolValue];
    rearCamBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"backCamera"] boolValue];
    screenTestBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"screenTest"] boolValue];
    screenShotBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"screenShot"] boolValue];
    volumeBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"volume"] boolValue];
    muteBool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mute"] boolValue];
    
    [deviceSummaryTableView reloadData];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_btnContinue setTitle:NSLocalizedStringFromTableInBundle(@"Continue", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
    [_btnCancel setTitle:NSLocalizedStringFromTableInBundle(@"Cancel", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
    _lblDeviceSummary.text = NSLocalizedStringFromTableInBundle(@"Device health check", nil, [[Helper sharedInstance] getLocalBundle], nil);

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuickCheckResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuickCheckResultTableViewCell"];
    if(!cell)
    {
        cell = [[QuickCheckResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.btnDisclosure.tag = indexPath.row;
    [cell.btnDisclosure addTarget:self action:@selector(actionBtnDisclosure:) forControlEvents:UIControlEventTouchUpInside];
    if(indexPath.row==0)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"volumeTest"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Volume", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(volumeBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    else if(indexPath.row==1)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"muteTest"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Mute", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(muteBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
        
    }
    else if (indexPath.row==2)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"screenshot"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Screenshot", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(screenShotBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    else if (indexPath.row==3)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"frontCamera"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Front camera", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(frontCamBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    else if (indexPath.row==4)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"BackCamera"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Back camera", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(rearCamBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    else if (indexPath.row==5)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"screenTes"];
        cell.lblLeft.text = @"Screen Test";
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Screen test", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(screenTestBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    else if(indexPath.row==6)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"wifi"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Wifi", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(wifiBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    else if(indexPath.row==7)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"data"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Data Connection", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(dataConnectionBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
        
    }
    else if (indexPath.row==8)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"bluetooth"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Bluetooth", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(bluetoothBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    else if (indexPath.row==9)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"gps"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"GPS", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(gpsBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    else if (indexPath.row==10)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"battery"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Battery", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(batteryBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    else if (indexPath.row==11)
    {
        cell.imgActivityLogo.image = [UIImage imageNamed:@"gyro"];
        cell.lblLeft.text = NSLocalizedStringFromTableInBundle(@"Gyroscope", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(gyroBool)
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"working"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor greenColor];
        }
        else
        {
            [cell.btnDisclosure setImage:[UIImage imageNamed:@"notworking"] forState:UIControlStateNormal];
            cell.btnDisclosure.tintColor = [UIColor redColor];
        }
    }
    
    return cell;
}

-(IBAction)actionBtnDisclosure:(UIButton *)btnDisclosure
{
    NSString *sendName;

    if(btnDisclosure.tag ==6)
    {
        if(!wifiBool)
        {
            sendName = NSLocalizedStringFromTableInBundle(@"Your WiFi connection has not been detected. Please check if your WiFi is turned on and connected to a working WiFi. You can see this in your device settings", nil, [[Helper sharedInstance] getLocalBundle], nil);

        }
    }
    else if (btnDisclosure.tag ==7)
    {
        if(!dataConnectionBool)
        {
            sendName =NSLocalizedStringFromTableInBundle(@"Your data connection has not been detected. Please check if your mobile data is turned on. You can find this in your device settings.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
        
    }
    else if (btnDisclosure.tag ==8)
    {
        if(!bluetoothBool)
        {
            sendName = NSLocalizedStringFromTableInBundle(@"Your Bluetooth capability has not been detected. Please check if your Bluetooth is turned on. You can find this in your device settings.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
    }
    else if (btnDisclosure.tag ==9)
    {
        if(!gpsBool)
        {
            sendName = NSLocalizedStringFromTableInBundle(@"Your GPS has not been detected. Please check if your GPS setting is turned on. You can find this in your device settings.", nil, [[Helper sharedInstance] getLocalBundle], nil);

            sendName = [[NSBundle mainBundle] localizedStringForKey:@"" value:@"" table:nil];
        }
    }
    else if (btnDisclosure.tag ==10)
    {
        if(!batteryBool)
        {
            sendName =NSLocalizedStringFromTableInBundle(@"Your battery doesn’t seem to be in working condition.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
    }
    else if (btnDisclosure.tag ==11)
    {
        if(!gyroBool)
        {
            sendName =NSLocalizedStringFromTableInBundle(@"Your device gyroscope doesn’t seem to be working.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        }
    }
    
    if(sendName.length>0)
    {
        LGAlertView *actionSheet = [LGAlertView alertViewWithTitle:@""
                                                           message:sendName
                                                             style:LGAlertViewStyleActionSheet
                                                      buttonTitles:@[]
                                                 cancelButtonTitle:nil
                                            destructiveButtonTitle:@"ok"
                                                          delegate:self];
        [actionSheet showAnimated];
    
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)ActionBack:(id)sender {
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
}

- (IBAction)ActionContinue:(id)sender {
    
//    BOOL tecExpert = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TECEXPERT"] boolValue];
//    if(!tecExpert)
//    {
//       // [self healthCheckApi];
//        SuccessViewController *successViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessViewController"];
//        successViewController.successTest = NO;
//        [self.navigationController pushViewController:successViewController animated:YES];
//    }
//    else
//    {
        if(volumeBool&&muteBool&&screenShotBool&&screenTestBool&&frontCamBool&&rearCamBool&&wifiBool&&dataConnectionBool&&bluetoothBool&&gpsBool&&batteryBool&&gyroBool)
        {
            SuccessViewController *successViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessViewController"];
            successViewController.successTest = YES;
            [self.navigationController pushViewController:successViewController animated:YES];
        }
        else
        {
            SuccessViewController *successViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessViewController"];
            successViewController.successTest = NO;
            [self.navigationController pushViewController:successViewController animated:YES];
        }
    //}
}
@end
