//
//  EditProfileViewController.m
//  AMTrust
//
//  Created by kishore kumar on 26/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()
{
    NSString *imageUrl;
    NSString*fbimages;
    
    
}
@end

@implementation EditProfileViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTableInBundle(@"Edit profile", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    backButton.tintColor = [Helper colorWithHexString:@"#FF304B"];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedStringFromTableInBundle(@"Save", nil, [[Helper sharedInstance] getLocalBundle], nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    
    
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"FBLOGIN"]  isEqual: @"YES"]) {
            imageUrl = [[NSUserDefaults standardUserDefaults ] objectForKey:@"FBPROFILEIMAGE"];
        }

    
    
    rightButton.tintColor = [Helper colorWithHexString:@"#FF304B"];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    profileDetails = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    
    [self profileDetails:@""];
    
    passwordOne = @"";
    passwordTwo = @"";
    oldPasswordString = @"";
    if (@available(iOS 11.0, *)) {
        editProfileTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupNIB];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *fbLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"FBLOGIN"];
    
    fbLoginCheck = [fbLogin boolValue];
    
    [[Helper sharedInstance] trackingScreen:@"Editprofile_ios"];
}

-(void)setupNIB
{
    [editProfileTableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TextFieldTableViewCell"];
    
    [editProfileTableView registerNib:[UINib nibWithNibName:@"ImageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ImageTableViewCell"];
    
    [editProfileTableView registerNib:[UINib nibWithNibName:@"ButtonTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ButtonTableViewCell"];
}

-(IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - profile details

-(void)profileDetails:(NSString *)check
{
    [SVProgressHUD showWithStatus:@"Profile info.."];
    
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    response.POSTDictionary =@{@"operation":@"ams.profile_detail",
                               @"sessionName":sessionName,
                               @"email_id":[profileDetails objectForKey:@"email"]//@"eltbutler@gmail.com"
                               };
    
    
    NSLog(@"this is profile data= %@",response.POSTDictionary);
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        @try {
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions
                                                                          error:&error];
            
            json = [json replaceNullsWithObject:@"NA"];
            
            BOOL success = [[json objectForKey:@"success"] boolValue];
            
            NSLog(@"profile value = %@",json);
            
            NSString *failure = [[json objectForKey:@"result"] objectForKey:@"status"];
            
            if(success)
            {
                [SVProgressHUD dismiss];
                
                if([failure isEqualToString:@"failure"])
                {
                    [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
                }
                else
                {
                    
                    NSDictionary *profileData = [[json objectForKey:@"result"] objectForKey:@"result"];
                    
                    addressStr = [NSString stringWithFormat:@"%@",[profileData objectForKey:@"address"]];
                    stateStr = [NSString stringWithFormat:@"%@",[profileData objectForKey:@"state"]];
                    countryStr = [NSString stringWithFormat:@"%@",[profileData objectForKey:@"country"]];
                    cityStr = [NSString stringWithFormat:@"%@",[profileData objectForKey:@"city"]];
                    firstName = [NSString stringWithFormat:@"%@",[profileData objectForKey:@"firstname"]];
                    lastName = [NSString stringWithFormat:@"%@",[profileData objectForKey:@"lastname"]];
                    postalCodeStr = [NSString stringWithFormat:@"%@",[profileData objectForKey:@"postal_code"]];
                    
                    NSString *customerId = [NSString stringWithFormat:@"%@",[profileData objectForKey:@"contactid"]];
                    passwordOne = @"";
                    passwordTwo = @"";
                    oldPasswordString = @"";
                    
                    NSString* noSpaces =
                    [NSString stringWithFormat:@"%@",[profileData objectForKey:@"profile_picture"]];
                    
                    profileDetails = @{@"customerid":customerId,
                                       @"firstname":firstName,
                                       @"lastname":lastName,
                                       @"email":[profileData objectForKey:@"email"],
                                       @"mobile":[profileData objectForKey:@"mobile"],
                                       @"imagename":[profileData objectForKey:@"profile_picture"],
                                       @"mailingstreet":addressStr,
                                       @"mailingcity":cityStr,
                                       @"mailingcountry":countryStr,
                                       @"mailingstate":stateStr,
                                       @"imagename":noSpaces
                                       };
                    
                    NSLog(@"no space = %@",noSpaces);
                    
                    [[NSUserDefaults standardUserDefaults] setObject:profileDetails forKey:@"profile"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    if([check isEqualToString:@"OK"])
                    {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    else
                    {
                        [editProfileTableView reloadData];
                    }
                }
            }
            else
            {
                [SVProgressHUD dismiss];
                [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
            }
        } @catch (NSException *exception) {
            [Helper catchPopUp:body titleForPopUp:@""];
        }
    };
    response.errorBlock = ^(NSError *error) {
        // ...
        [SVProgressHUD dismiss];
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    };
    
    [response startAsynchronous];
    
}

-(void)updateProfileInfo
{
    if(firstName.length==0)
    {
        [Helper popUpMessage:@"First name is missing" titleForPopUp:@"First name field is empty" view:[UIView new]];
    }
    else if (lastName.length==0)
    {
        [Helper popUpMessage:@"Last name is missing" titleForPopUp:@"Last name field is empty" view:[UIView new]];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"updating profile.."];
        
        NSString *deviceName = @"IPHONE";
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad){
            deviceName=@"IPAD";
        }
        
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        
        if(deviceToken.length == 0)
        {
            deviceToken = @"NO TOKEN";
        }
        
        NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
        
        NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
        
        NSString *strCountry = [[NSUserDefaults standardUserDefaults] objectForKey:@"Country"];
        
        NSDictionary *elementDictionary =@{
                                           @"firstname":firstName,
                                           @"lastname":lastName,
                                           @"email":[profileDetails objectForKey:@"email"],
                                           @"mobile":[NSString stringWithFormat:@"%@",[profileDetails objectForKey:@"mobile"]],
                                           @"mailingstreet":addressStr,
                                           @"cf_1277":deviceToken,//device token
                                           @"cf_1281":[[Helper sharedInstance] deviceModelName],//cf_1281 device version
                                           @"cf_1372":@"IOS",
                                           @"cf_1279":deviceName,//device model
                                           @"assigned_user_id":assignedUserId,
                                           @"mailingpobox":postalCodeStr,
                                           @"mailingstate":stateStr,
                                           @"mailingcountry":countryStr,
                                           @"mailingcity":cityStr,
                                           @"cf_1283":[NSString stringWithFormat:@"70x%@",strCountry],
                                           @"portal":@"1",
                                           @"id":[profileDetails objectForKey:@"customerid"]
                                           };
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:elementDictionary // Here you can pass array or dictionary
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        NSString *jsonString;
        if (jsonData) {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            //This is your JSON String
            //NSUTF8StringEncoding encodes special characters using an escaping scheme
        } else {
            NSLog(@"Got an error: %@", error);
            jsonString = @"";
        }
        NSLog(@"Your JSON String is %@", jsonString);
        
        
        NSDictionary *paramDictionary=[NSDictionary dictionaryWithObjectsAndKeys:
                                       @"ams.update_profile", @"operation",
                                       sessionName,@"sessionName",
                                       jsonData,@"element",
                                       nil];
        
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        
        NSMutableURLRequest *request;
        
        NSData *imageData = UIImageJPEGRepresentation(profileChoosedImage, 0.6);
        
        if(profileChoosedImage)
        {
            request=[serializer multipartFormRequestWithMethod:@"POST" URLString:BASEURL parameters:paramDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                     {
                         if(imageData)
                         {
                             [formData appendPartWithFileData:imageData
                                                         name:@"filedata"
                                                     fileName:[NSString stringWithFormat:@"%@.jpg",sessionName]
                                                     mimeType:@"image/jpg"];
                             
                         }
                     } error:nil];
        }
        else
        {
            request=[serializer multipartFormRequestWithMethod:@"POST" URLString:BASEURL parameters:paramDictionary constructingBodyWithBlock:nil error:nil];
        }
        
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        jsonResponseSerializer.acceptableContentTypes = nil;
        manager.responseSerializer = jsonResponseSerializer;
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress)
                      {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(),
                                         ^{
                                             //Update the progress view
                                             
                                         });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull responseObject, id  _Nullable response, NSError * _Nullable error) {
                          if (!error) {
                              BOOL success=[[response objectForKey:@"success"] boolValue];
                              
                              if(success)
                              {
                                  NSString *status=[NSString stringWithFormat:@"%@",[[response objectForKey:@"result"] objectForKey:@"status"]];
                                  if([status isEqualToString:@"failure"])
                                  {
                                      [Helper popUpMessage:[[response objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
                                  }
                                  else
                                  {
                                      [self profileDetails:@"OK"];
                                  }
                              }
                          }
                          
                          [SVProgressHUD dismiss];
                          
                      }];
        
        [uploadTask resume];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }else if (section==1){
        if(fbLoginCheck)
        {
            return 0;
        }else{
            return 1;
        }
    }else if (section==2){
        return 4;
    }else{
        return 3;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageTableViewCell"];
        if(!cell)
        {
            cell = [[ImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ImageTableViewCell"];
        }
        [cell.btnCamera addTarget:self action:@selector(ActionProfileImage:) forControlEvents:UIControlEventTouchUpInside];
         imageUrl = [profileDetails objectForKey:@"imagename"];
        
        if(profileChoosedImage != nil)
        {
            cell.profileImageView.image = profileChoosedImage;
//            cell.profileImageView.image = fbimages;
            
        
        }else{
          
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"FBLOGIN"]  isEqual: @"YES"] && [imageUrl  isEqual: @"No Picture Uploaded"]) {
                
                imageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"FBPROFILEIMAGE"];
            }
           
            [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"manPlaceholder"]];
        }
        return cell;
    }
    else
    {
        TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell"];
        if(!cell)
        {
            cell = [[TextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextFieldTableViewCell"];
        }
        cell.profileTextField.tag = indexPath.row;
        cell.btnEmailQuestion.tag = indexPath.row;
        cell.btnPassword.hidden = YES;
        cell.btnEmailQuestion.hidden = YES;
        cell.profileTextField.enabled = YES;
        cell.btnPassword.tag = indexPath.row;
        cell.profileTextField.delegate = self;
        
        if (indexPath.section==1)
        {
            //ButtonTableViewCell
            ButtonTableViewCell *cellButton = [tableView dequeueReusableCellWithIdentifier:@"ButtonTableViewCell"];
            if(!cellButton)
            {
                cellButton = [[ButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextFieldTableViewCell"];
            }
            [cellButton.btnPassword setTitle:NSLocalizedStringFromTableInBundle(@"Change password", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
            [cellButton.btnPassword addTarget:self action:@selector(ActionChangePassword:) forControlEvents:UIControlEventTouchUpInside];
            
            return cellButton;
            
        }else if(indexPath.section==2){
            
            cell.btnEmailQuestion.frame = CGRectMake(self.view.frame.size.width - 35, 10, 25, 25);
            [cell.btnEmailQuestion addTarget:self action:@selector(ActionPopMenu:) forControlEvents:UIControlEventTouchUpInside];
            if(indexPath.row==0)
            {
                cell.profileTextField.placeholder = NSLocalizedStringFromTableInBundle(@"First name", nil, [[Helper sharedInstance] getLocalBundle], nil);
                cell.profileTextField.text =  [NSString stringWithFormat:@"%@",[profileDetails objectForKey:@"firstname"]];
            }
            if(indexPath.row==1)
            {
                cell.profileTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Last name", nil, [[Helper sharedInstance] getLocalBundle], nil);
                cell.profileTextField.text =  [NSString stringWithFormat:@"%@",[profileDetails objectForKey:@"lastname"]];
            }
            else if (indexPath.row==2)
            {
                cell.profileTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Email", nil, [[Helper sharedInstance] getLocalBundle], nil);
                cell.btnEmailQuestion.hidden = NO;
                cell.profileTextField.enabled = NO;
                cell.profileTextField.text =  [NSString stringWithFormat:@"%@",[profileDetails objectForKey:@"email"]];
                
            }
            else if (indexPath.row==3)
            {
                cell.profileTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Phone number", nil, [[Helper sharedInstance] getLocalBundle], nil);
                cell.profileTextField.enabled = NO;
                cell.btnEmailQuestion.hidden = NO;
                cell.profileTextField.text =  [NSString stringWithFormat:@"%@",[profileDetails objectForKey:@"mobile"]];
            }
            
        }else{
            
            cell.profileTextField.tag = indexPath.row;
            
            if(indexPath.row == 0)
            {
                cell.profileTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Address Line 1", nil, [[Helper sharedInstance] getLocalBundle], nil);
                
                if([[Helper sharedInstance] checkForNull:addressStr])
                    cell.profileTextField.text = @"";
                else
                    cell.profileTextField.text =  addressStr;
                
            }else if(indexPath.row == 1)
            {
                cell.profileTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Address Line 2", nil, [[Helper sharedInstance] getLocalBundle], nil);
                
                if([[Helper sharedInstance] checkForNull:cityStr])
                    cell.profileTextField.text = @"";
                else
                    cell.profileTextField.text =  cityStr;
            }
            else if (indexPath.row == 2)
            {
                cell.profileTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Postal Code", nil, [[Helper sharedInstance] getLocalBundle], nil);
                
                if([[Helper sharedInstance] checkForNull:postalCodeStr])
                    cell.profileTextField.text = @"";
                else
                    cell.profileTextField.text =  postalCodeStr;
            }
        }
        return cell;
    }
}

//-(void)sendImageValues:(NSString*)fbImage
//{
//    fbimages = fbImage;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        if (@available(iOS 11.0, *)) {
            return 0.000001;
        } else {
            return 0;
        }
    }else if (section==2)
    {
        if(fbLoginCheck){
            return 0.1;
        }
    }
    
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return 0.000001;
    } else {
        return 0.0000001;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return @"";
    }
    else if (section==2)
    {
        NSString *title = NSLocalizedStringFromTableInBundle(@"Personal details", nil, [[Helper sharedInstance] getLocalBundle], nil);
        return title;
    }
    else if (section==1)
    {
        if(fbLoginCheck)
        {
            return @"";
        }
        else
        {
            NSString *title = NSLocalizedStringFromTableInBundle(@"Manage Password", nil, [[Helper sharedInstance] getLocalBundle], nil);
            return title;
        }
    }
    else
    {
        NSString *title = NSLocalizedStringFromTableInBundle(@"Address Info", nil, [[Helper sharedInstance] getLocalBundle], nil);
        return title;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 250;
    }else if (indexPath.section==1)
    {
        if(fbLoginCheck){
            return 0;
        }
    }
    
    return 60;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
        tableViewHeaderFooterView.textLabel.textColor = [UIColor grayColor];
        tableViewHeaderFooterView.textLabel.font = [UIFont boldSystemFontOfSize:15];
    }
}


#pragma mark profile image picking

-(IBAction)ActionProfileImage:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Select Profile Picture"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Take A Photo" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [self takeBarButtonClick:nil];
                                                         }];
    
    UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"From Gallery" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self openBarButtonClick:nil];
                                                              
                                                          }];
    
    UIAlertAction * defaultAct = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * action) {}];
    
    [alert addAction:cameraAction];
    [alert addAction:galleryAction];
    [alert addAction:defaultAct];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)ActionChangePassword:(id)sender
{
    ChangePasswordViewController *changePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    [self.navigationController pushViewController:changePasswordViewController animated:YES];
}

- (IBAction)takeBarButtonClick:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:self];
        imagePicker.allowsEditing = NO;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning"
                                     message:@"Your device doesn't have a camera."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)openBarButtonClick:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^{
        profileChoosedImage = image;
    }];
    profileChoosedImage = image;
    urlString  = [editingInfo valueForKey:UIImagePickerControllerReferenceURL];
    
    [editProfileTableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    profileChoosedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSString*str = UIImagePickerControllerOriginalImage;
    urlString  = [info valueForKey:UIImagePickerControllerReferenceURL];
    [editProfileTableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnPassword:(id)sender
{
    UIButton *btnPassword = (UIButton *)sender;
    
    if(btnPassword.tag == 0){
        if(oldPassword){
            oldPassword = NO;
        }else{
            oldPassword = YES;
        }
    }else if(btnPassword.tag == 1){
        if(password){
            password = NO;
        }else{
            password = YES;
        }
    }else{
        if(confirmPassword){
            confirmPassword = NO;
        }else{
            confirmPassword = YES;
        }
    }
    
    [editProfileTableView reloadData];
}

-(IBAction)ActionPopMenu:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    NSString *cancel = NSLocalizedStringFromTableInBundle(@"Cancel", nil, [[Helper sharedInstance] getLocalBundle], nil);
    
    if(btn.tag == 2)
    {
        LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:@"To change email address, please call our customer center at 0804-1401-078" style:LGAlertViewStyleAlert buttonTitles:@[@"Call",cancel] cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
            if([title isEqualToString:@"Call"])
            {
                NSString *phoneNumber = [@"tel://" stringByAppendingString:@"08041401078"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            }
            
        } cancelHandler:^(LGAlertView * _Nonnull alertView) {
            
        } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
            
        }];
        alertView.tintColor = THEMECOLOR;
        [alertView show];
    }
    else
    {
        LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:@"To change Phone number, please call our customer center at 0804-1401-078" style:LGAlertViewStyleAlert buttonTitles:@[@"Call",cancel] cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
            if([title isEqualToString:@"Call"])
            {
                NSString *phoneNumber = [@"tel://" stringByAppendingString:@"08041401078"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                
            }
            
        } cancelHandler:^(LGAlertView * _Nonnull alertView) {
            
        } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
            
        }];
        alertView.tintColor = THEMECOLOR;
        [alertView show];
    }
}

-(IBAction)saveAction:(id)sender
{
    [self updateProfileInfo];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    TextFieldTableViewCell *cell = (TextFieldTableViewCell*) textField.superview.superview;
    NSIndexPath *txtIndPath = [editProfileTableView indexPathForCell:cell];
    
    if (txtIndPath.section==3)
    {
        if(textField.tag == 0){
            addressStr = newString;
        }else if (textField.tag == 1){
            cityStr = newString;
        }else{
            postalCodeStr = newString;
        }
    }
    else if (txtIndPath.section==2)
    {
        if(textField.tag==0){
            firstName = newString;
        }else if (textField.tag==1){
            lastName = newString;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

