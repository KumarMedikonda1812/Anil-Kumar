//
//  SuccessViewControllerLost.m
//  TecProtec
//
//  Created by kishore kumar on 09/09/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "SuccessViewControllerLost.h"

@interface SuccessViewControllerLost ()

@end

@implementation SuccessViewControllerLost
@synthesize success;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lblMessage.text = _successMessage;

    if(success)
    {
        _imgSuccess.image = [UIImage imageNamed:@"success"];
        
        NSString *continueText = NSLocalizedStringFromTableInBundle(@"Upload", nil, [[Helper sharedInstance] getLocalBundle], nil);
        [_btn setTitle:continueText forState:UIControlStateNormal];
    }
    else
    {
        _imgSuccess.image = [UIImage imageNamed:@"error"];
        NSString *continueText = NSLocalizedStringFromTableInBundle(@"Continue", nil, [[Helper sharedInstance] getLocalBundle], nil);
        [_btn setTitle:continueText forState:UIControlStateNormal];
    }
}
-(void)crackScreenServiceRequest
{
    [SVProgressHUD showWithStatus:@"Loading...."];
    STHTTPRequest *response = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",BASEURL]];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    
    NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
    //contactid
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"]);
    NSString *customerID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profile"] objectForKey:@"customerid"];
    //{
    
    NSDictionary *elementDictionary =@{@"title":@"SalesOrder",
                                       @"contact_id":customerID,
                                       @"parent_id":@"0",
                                       @"priority":@"Low",
                                       @"product_id":@"0",
                                       @"severity":@"Low",
                                       @"status":@"Open",
                                       @"category":@"category",
                                       @"hours":@"21.05",
                                       @"days":@"2",
                                       @"description":@"Receipt upload",
                                       @"solution":@"solution of ticket",
                                       @"policyid":_policyId
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
    
    response.POSTDictionary = @{@"operation":@"ams.createservicerequest",
                                @"sessionName":sessionName,
                                @"userId":assignedUserId,
                                @"element":jsonString
                                };
    
    
    
    NSLog(@"PARAMETER = %@",response.POSTDictionary);
    
    response.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSError* error;
        
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        
        json = [json replaceNullsWithObject:@"NA"];

        BOOL success = [[json objectForKey:@"success"] boolValue];
        NSString *failure = [[json objectForKey:@"result"] objectForKey:@"status"];
        
        NSLog(@"RESPONSE = %@",json);

        if(success)
        {
            [SVProgressHUD dismiss];
            
            if([failure isEqualToString:@"failure"]||[failure isEqualToString:@"failed"])
            {
                [Helper popUpMessage:[[json objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
            }
            else
            {
                [self documentRequest:_policyId];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            [Helper popUpMessage:[[json objectForKey:@"error"] objectForKey:@"message"] titleForPopUp:@"Error" view:[UIView new]];
        }
    };
    response.errorBlock = ^(NSError *error) {
        // ...
        [SVProgressHUD dismiss];
        [Helper popUpMessage:error.localizedDescription titleForPopUp:@"Error" view:[UIView new]];
    };
    
    [response startAsynchronous];
    
    
}
-(void)documentRequest:(NSString *)serviceid
{
    
    [SVProgressHUD showWithStatus:@"Uploading...."];
    
    NSString *sessionName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    NSString *assignedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"result"] objectForKey:@"userId"];
    //contactid
    
    //	"notes_title": "New Document",
    
    NSDictionary *elementDictionary =@{@"notes_title":@"Note documents",
                                       @"record_id":serviceid,
                                       @"notecontent":@"note content",
                                       @"type":@"SalesOrder"
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
    
    NSDictionary *paramDictionary = @{@"operation":@"ams.createdocument",
                                      @"sessionName":sessionName,
                                      @"userId":assignedUserId,
                                      @"element":jsonString
                                      };
    NSMutableURLRequest *request;
    
    NSLog(@"Your JSON String is %@", paramDictionary);
    
    NSData *imageData = UIImageJPEGRepresentation(imgScreen, 1);
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    if(imgScreen)
    {
        request=[serializer multipartFormRequestWithMethod:@"POST" URLString:BASEURL parameters:paramDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                 {
                     if(imageData)
                     {
                         [formData appendPartWithFileData:imageData
                                                     name:@"document"
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
                      if (error) {
                          
                      } else
                      {
                          NSLog(@"%@ %@", response, responseObject);
                          BOOL successs=[[response objectForKey:@"success"] boolValue];
                          if(successs)
                          {
                              NSString *status=[NSString stringWithFormat:@"%@",[[response objectForKey:@"result"] objectForKey:@"status"]];
                              if([status isEqualToString:@"failure"])
                              {
                                   [Helper popUpMessage:[[response objectForKey:@"result"] objectForKey:@"message"] titleForPopUp:@"Alert" view:[UIView new]];
                              }
                              else
                              {
                                  [self.navigationController popToRootViewControllerAnimated:YES];
                              }
                              
                          }
                          else
                          {
                              
                          }
                          
                          
                      }
                      [SVProgressHUD dismiss];
                  }];
    
    [uploadTask resume];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    imgScreen = [info objectForKey:UIImagePickerControllerOriginalImage];
    picker.cameraDevice =  UIImagePickerControllerCameraDeviceRear;
    [self crackScreenServiceRequest];
    [picker dismissViewControllerAnimated:YES completion:nil];
}




- (IBAction)ActionSuccess:(id)sender {
    
    if(success)
    {
        NSString *strText = NSLocalizedStringFromTableInBundle(@"Take photo", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        NSString *strTitle = NSLocalizedStringFromTableInBundle(@"Upload Invoice Receipt", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        NSString *photoString = NSLocalizedStringFromTableInBundle(@"Choose from photo library", nil, [[Helper sharedInstance] getLocalBundle], nil);

        LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:strTitle style:LGAlertViewStyleAlert buttonTitles:@[strText,photoString] cancelButtonTitle:@"Upload later" destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
            if([title isEqualToString:@"Choose from photo library"]||[title isEqualToString:@"Pilih dari galeri foto"])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [imagePicker setDelegate:self];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                [imagePicker setDelegate:self];
                imagePicker.allowsEditing = NO;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            
        } cancelHandler:^(LGAlertView * _Nonnull alertView) {
            UITabBarController *homeTab = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabBarController"];
            [self presentViewController:homeTab animated:YES completion:nil];
            
        } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
           
        }];
        
        alertView.tintColor = THEMECOLOR;
        [alertView show];
    }
    else
    {

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
