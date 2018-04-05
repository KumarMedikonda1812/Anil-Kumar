//
//  QuickDiagonasisTestViewController.m
//  Tecprotec
//
//  Created by kishore kumar on 09/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "QuickDiagonasisTestViewController.h"
#import "DemoNavigationController.h"
#import "DBCameraViewController.h"
#import "DBCameraContainerViewController.h"
#import "DBCameraLibraryViewController.h"
#import "CustomCamera.h"
#import "DBCameraGridView.h"
#import "DBCameraConfiguration.h"


@interface DetailViewController : UIViewController {
    UIImageView *_imageView;
}
@property (nonatomic, strong) UIImage *detailImage;
@end

@implementation DetailViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
#endif
    
    [self.navigationItem setTitle:@"Detail"];
    
    _imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_imageView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_imageView setImage:_detailImage];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _detailImage = nil;
    [_imageView setImage:nil];
}

@end

#define kCellIdentifier @"CellIdentifier"
#define kCameraTitles @[ @"Open Camera", @"Open Custom Camera", @"Open Camera without Segue", @"Open Camera without Container", @"Camera with force quad crop", @"Open Library Picker" ]

typedef void (^TableRowBlock)();

@interface QuickDiagonasisTestViewController () <DBCameraViewControllerDelegate>{
    NSDictionary *_actionMapping;
    
}
@end

@implementation QuickDiagonasisTestViewController
@synthesize textCollectionView,pageController,btnContinue,btnCancel;

- (id) init
{
    self = [super init];
    
    if ( self ) {
        _actionMapping = @{ @0:^{ [self openCustomCamera]; }, @1:^{ [self openCustomCamera]; },
                            @2:^{ [self openCameraWithoutSegue]; }, @3:^{ [self openCameraWithoutContainer]; },
                            @4:^{ [self openCameraWithForceQuad]; }, @5:^{ [self openLibrary]; } };
    }
    
    return self;
}

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
#endif
    
    [super viewDidLoad];
    
    imagePicker = [[UIImagePickerController alloc] init];
    
    [textCollectionView registerNib:[UINib nibWithNibName:@"TestCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TestCollectionViewCell"];
    
    
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    currentVolume = audioSession.outputVolume;
    NSLog(@"current volume %@",[NSString stringWithFormat:@"%f",currentVolume]);
    
    if(currentVolume==1)
    {
        
        [Helper popUpMessage:NSLocalizedStringFromTableInBundle(@"Your volume is already maximum please reduce the volume and increase again", nil, [[Helper sharedInstance] getLocalBundle], nil) titleForPopUp:@""
                 buttonTitle:@"Ok"];
    }
    
    tecExpert = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TECEXPERT"] boolValue];
    screenTestDelegateBool = YES;
    if(tecExpert)
    {
        pageController.numberOfPages = 7;
    }
    else
    {
        pageController.numberOfPages = 8;
    }
    
    [audioSession setActive:YES error:nil];
    [audioSession addObserver:self
                   forKeyPath:@"outputVolume"
                      options:0
                      context:nil];
    
    self.muteChecker = [[MuteChecker alloc] initWithCompletionBlk:^(NSTimeInterval lapse, BOOL muted) {
        NSLog(@"lapsed: %f", lapse);
        NSLog(@"muted: %d", muted);
        
        if(muted)
        {
            muteBool = YES;
            [textCollectionView reloadData];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"mute"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"mute"]; [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    }];
    
    btnContinue.hidden = YES;
    
    imgScreen = [[UIImage alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Helper sharedInstance] trackingScreen:@"Healthcheck_IOS"];
    
    [btnContinue setTitle:NSLocalizedStringFromTableInBundle(@"Continue", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
    [btnCancel setTitle:NSLocalizedStringFromTableInBundle(@"Cancel", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(tecExpert)
    {
        return 7;
    }
    else
    {
        return 8;
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestCollectionViewCell" forIndexPath:indexPath];
    cell.checkBox.hidden = YES;
    cell.secondImageView.hidden = NO;
    if(indexPath.row==0)
    {
        cell.lblHeader.text = NSLocalizedStringFromTableInBundle(@"Volume Test", nil, [[Helper sharedInstance] getLocalBundle], nil);
        cell.lblDetails.text = NSLocalizedStringFromTableInBundle(@"Increase volume up to maximum level using the buttons available on the sides.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(volumeIncrease)
        {
            cell.checkBox.hidden = NO;
            cell.checkBox.on = YES;
            cell.secondImageView.hidden = YES;
            [self timerMethod];
        }
        else
        {
            cell.secondImageView.image = [UIImage imageNamed:@"oneS"];
        }
        cell.testImageView.image = [UIImage imageNamed:@"one"];
    }
    else if (indexPath.row==1)
    {
        cell.lblHeader.text = NSLocalizedStringFromTableInBundle(@"Volume Test", nil, [[Helper sharedInstance] getLocalBundle], nil);
        cell.lblDetails.text = NSLocalizedStringFromTableInBundle(@"Decrease volume up to minimum level using the buttons available on the sides.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        if(volumeDecrease)
        {
            cell.checkBox.hidden = NO;
            cell.checkBox.on = YES;
            cell.secondImageView.hidden = YES;
            [self timerMethod];
        }
        else
        {
            cell.secondImageView.image = [UIImage imageNamed:@"oneS"];
        }
        cell.testImageView.image = [UIImage imageNamed:@"volume_down"];
    }
    else if (indexPath.row==2)
    {
        cell.lblHeader.text = NSLocalizedStringFromTableInBundle(@"Mute test", nil, [[Helper sharedInstance] getLocalBundle], nil);
        cell.lblDetails.text = NSLocalizedStringFromTableInBundle(@"Toggle button to mute and then press the “Test Now” button below", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        if(muteBool)
        {
            cell.checkBox.hidden = NO;
            cell.checkBox.on = YES;
            cell.secondImageView.hidden = YES;
            
            [self timerMethod];
        }
        else
        {
            cell.secondImageView.image = [UIImage imageNamed:@"twoS"];
        }
        cell.testImageView.image = [UIImage imageNamed:@"two"];
    }
    else if (indexPath.row==3)
    {
        cell.lblHeader.text = NSLocalizedStringFromTableInBundle(@"Screenshot", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        cell.lblDetails.text = NSLocalizedStringFromTableInBundle(@"Take a screenshot by pressing the home and power buttons at the same time", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        if(screenShotBool)
        {
            cell.checkBox.hidden = NO;
            cell.checkBox.on = YES;
            cell.secondImageView.hidden = YES;
            
            [self timerMethod];
        }
        else
        {
            cell.secondImageView.image = [UIImage imageNamed:@"threeS"];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenshotDetected) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
            
        }
        cell.testImageView.image = [UIImage imageNamed:@"three"];
    }
    else if (indexPath.row==4)
    {
        cell.lblHeader.text = NSLocalizedStringFromTableInBundle(@"front camera", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        cell.lblDetails.text = NSLocalizedStringFromTableInBundle(@"Press the camera icon  to open your front camera. We’ll take picture in a few seconds.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        if(frontCamera)
        {
            cell.checkBox.hidden = NO;
            cell.checkBox.on = YES;
            cell.secondImageView.hidden = YES;
            
            [self timerMethod];
        }
        else
        {            cell.secondImageView.image = [UIImage imageNamed:@"fourS"];
        }
        cell.testImageView.image = [UIImage imageNamed:@"four"];
        
    }
    else if (indexPath.row==5)
    {
        
        cell.lblHeader.text = NSLocalizedStringFromTableInBundle(@"Back camera", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        cell.lblDetails.text = NSLocalizedStringFromTableInBundle(@"Press the camera icon  to open your back camera. We’ll take picture in a few seconds.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        if(backCamera)
        {
            cell.checkBox.hidden = NO;
            cell.checkBox.on = YES;
            cell.testImageView.image = [UIImage imageNamed:@"seven"];
            [self timerMethod];
            cell.secondImageView.hidden = NO;
        }
        else
        {
            cell.testImageView.image = [UIImage imageNamed:@"five"];
        }
        cell.secondImageView.hidden = YES;
    }
    else if (indexPath.row==6)
    {
        //screenTest
        if(screenBool)
        {
            if(screenTestDelegateBool)
            {
                cell.testImageView.image = [UIImage imageNamed:@"seven"];
                cell.checkBox.hidden = NO;
                cell.checkBox.on = YES;
                cell.secondImageView.hidden = YES;
            }
            else
            {
                if(tecExpert)
                {
                    QuickCheckResultViewController *touchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickCheckResultViewController"];
                    [self.navigationController pushViewController:touchViewController animated:YES];
                }
            }
            if(!tecExpert)
            {
                [self timerMethod];
            }
        }
        else
        {
            cell.testImageView.image = [UIImage imageNamed:@"six"];
        }
        cell.secondImageView.hidden = YES;
        cell.lblHeader.text = NSLocalizedStringFromTableInBundle(@"Screen test", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        cell.lblDetails.text = NSLocalizedStringFromTableInBundle(@"On the next screen, tap or swipe each grey square to test the touch surface", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
    }
    else if (indexPath.row==7)
    {
        //
        if(screenCheckBool)
        {
            // cell.checkBox.hidden = NO;
            // cell.checkBox.on = YES;
            cell.secondImageView.image =  [UIImage imageNamed:@"sevenS"];
        }
        else
        {
            cell.secondImageView.image = [UIImage imageNamed:@"sevenS"];
        }
        cell.secondImageView.hidden = NO;
        cell.lblHeader.text = NSLocalizedStringFromTableInBundle(@"Screen check", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        cell.lblDetails.text = NSLocalizedStringFromTableInBundle(@"You need a mirror to perform this test.  Place your device in front of a mirror with the screen facing the mirror and take a photo of the screen by pressing Continue.", nil, [[Helper sharedInstance] getLocalBundle], nil);
        
        cell.testImageView.image = [UIImage imageNamed:@"seven"];
    }
    
    return cell;
}

-(void)timerMethod
{
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(timer:)
                                   userInfo:nil
                                    repeats:YES];
    number = 1;
}
- (void)timer:(NSTimer *)timer{
    
    number--;
    
    if (number == 0 ) {
        [timer invalidate];
        
        NSArray *visibleItems = [textCollectionView indexPathsForVisibleItems];
        NSIndexPath *currentItem = [visibleItems objectAtIndex:0];
        NSIndexPath *nextItem = [NSIndexPath indexPathForItem:currentItem.item + 1 inSection:currentItem.section];
        [textCollectionView scrollToItemAtIndexPath:nextItem atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        //after updated
        btnContinue.tag = currentItem.item+1;
        pageController.currentPage = currentItem.item+1;
        [btnContinue addTarget:self action:@selector(actionContinue:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger screenPagePosition = currentItem.item+1;
        
        if(screenPagePosition==4||screenPagePosition==5)
        {
            btnContinue.hidden = NO;
            [btnContinue setTitle:NSLocalizedStringFromTableInBundle(@"Open Camera", nil, [[Helper sharedInstance] getLocalBundle], nil)
                         forState:UIControlStateNormal];
        }
        else if (screenPagePosition==2)
        {
            btnContinue.hidden = NO;
            [btnContinue setTitle:NSLocalizedStringFromTableInBundle(@"Test now", nil, [[Helper sharedInstance] getLocalBundle], nil) forState:UIControlStateNormal];
            
        }
        else if (screenPagePosition==6||screenPagePosition==7)
        {
            btnContinue.hidden = NO;
            [btnContinue setTitle:NSLocalizedStringFromTableInBundle(@"Continue", nil, [[Helper sharedInstance] getLocalBundle], nil)
                         forState:UIControlStateNormal];
        }
        else
        {
            btnContinue.hidden = YES;
        }
        
    }
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    CGFloat volume = audioSession.outputVolume;
    NSLog(@"volume test = %@",[NSString stringWithFormat:@"%f",volume]);
    
    if(volume > currentVolume)
    {
        currentVolume = volume;
        if(currentVolume == 1)
        {
            volumeIncrease = YES;
            [textCollectionView reloadData];
        }
    }else{
        currentVolume = volume;
        if(currentVolume == 0)
        {
            if(volumeIncrease)
            {
                volumeDecrease = YES;
                [textCollectionView reloadData];
                volumeTestBool = YES;
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"volume"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        }
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    for (UICollectionViewCell *cell in [textCollectionView visibleCells]) {
        NSIndexPath *indexPath = [textCollectionView indexPathForCell:cell];
        
        NSLog(@"%@",indexPath);
    }
}


#pragma mark - Camera Actions

- (void) openCamera
{
    
    DBCameraConfiguration *configuration = [[DBCameraConfiguration alloc] init];
    configuration.configureProcessingController = ^(UIViewController <DBPhotoProcessingControllerProtocol> * _Nonnull controller) {
    };
    configuration.configureCameraController = ^(UIViewController < DBCameraControllerProtocol > * _Nonnull controller) {
    };
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self cameraConfiguration:configuration];
    [cameraContainer setFullScreenMode];
    
    DemoNavigationController *nav = [[DemoNavigationController alloc] initWithRootViewController:cameraContainer];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) openCustomCamera
{
    CustomCamera *camera = [CustomCamera initWithFrame:[[UIScreen mainScreen] bounds]];
    [camera buildInterface];
    
    DemoNavigationController *nav = [[DemoNavigationController alloc] initWithRootViewController:[[DBCameraViewController alloc] initWithDelegate:self cameraView:camera]];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void) openCameraWithoutSegue
{
    DBCameraViewController *cameraController = [DBCameraViewController initWithDelegate:self];
    [cameraController setUseCameraSegue:NO];
    DBCameraContainerViewController *container = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [container setCameraViewController:cameraController];
    [container setFullScreenMode];
    DemoNavigationController *nav = [[DemoNavigationController alloc] initWithRootViewController:container];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) openCameraWithForceQuad
{
    DBCameraViewController *cameraController = [DBCameraViewController initWithDelegate:self];
    [cameraController setForceQuadCrop:YES];
    
    DBCameraContainerViewController *container = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [container setCameraViewController:cameraController];
    [container setFullScreenMode];
    
    DemoNavigationController *nav = [[DemoNavigationController alloc] initWithRootViewController:container];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) openCameraWithoutContainer
{
    DemoNavigationController *nav = [[DemoNavigationController alloc] initWithRootViewController:[DBCameraViewController initWithDelegate:self]];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) openLibrary
{
    DBCameraLibraryViewController *vc = [[DBCameraLibraryViewController alloc] init];
    [vc setDelegate:self];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - DBCameraViewControllerDelegate

- (void) dismissCamera:(id)cameraViewController{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    imgScreen = [metadata objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    if(cameraSplit==4)
    {
        frontCamera = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"frontCamera"];
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"frontCameraImage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (cameraSplit==7)
    {
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"crackScreenImage"];
        screenCheckBool = YES;
        [[NSUserDefaults standardUserDefaults] synchronize];
        QuickCheckResultViewController *touchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickCheckResultViewController"];
        [self.navigationController pushViewController:touchViewController animated:YES];
    }
    else
    {
        backCamera = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"backCamera"];
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"backCameraImage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    [textCollectionView reloadData];
    
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
}

-(IBAction)actionContinue:(id)sender
{
    UIButton *btnCon = (UIButton *)sender;
    
    if(btnCon.tag==4||btnCon.tag==5||btnCon.tag==7)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            DBCameraConfiguration *configuration = [[DBCameraConfiguration alloc] init];
            configuration.configureProcessingController = ^(UIViewController <DBPhotoProcessingControllerProtocol> * _Nonnull controller)
            {
                controller.cropButton.hidden = YES;
                controller.filtersBarVisible = NO;
            };
            
            configuration.configureCameraController = ^(UIViewController < DBCameraControllerProtocol > * _Nonnull controller) {
                if(btnCon.tag==4||btnCon.tag==7){
                    controller.initialCameraPosition = AVCaptureDevicePositionFront;
                    
                }else{
                    controller.initialCameraPosition = AVCaptureDevicePositionBack;
                    
                }
            };
            
            DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self cameraConfiguration:configuration];
            [cameraContainer setFullScreenMode];
            
            DemoNavigationController *nav = [[DemoNavigationController alloc] initWithRootViewController:cameraContainer];
            [self presentViewController:nav animated:YES completion:nil];
            
            cameraSplit = btnCon.tag;
            [self openCamera];
            
        }else{
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
    else if (btnCon.tag==6)
    {
        NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguage"];
        
        NSString *startMsg = @"Start";
        
        if([language isEqualToString:@"id"])
        {
            startMsg = @"Mulai";
        }
        
        LGAlertView *alertView = [[LGAlertView alloc]initWithTitle:@"" message:NSLocalizedStringFromTableInBundle(@"Please finish the screen test with in 10 seconds.", nil, [[Helper sharedInstance] getLocalBundle], nil) style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:startMsg destructiveButtonTitle:nil actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        } cancelHandler:^(LGAlertView * _Nonnull alertView) {
            
            TouchViewController *touchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TouchViewController"];
            touchViewController.delegate = self;
            [self presentViewController:touchViewController animated:YES completion:nil];
            
        } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
            
            screenBool = YES;
            screenTestDelegateBool = NO;
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"screenTest"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [textCollectionView reloadData];
            
        }];
        alertView.tintColor = THEMECOLOR;
        [alertView show];
    }
    else if (btnCon.tag==2)
    {
        [_muteChecker check];
    }
    
}

-(void)screenshotDetected
{
    [self timerMethod];
    screenShotBool = YES;
    [textCollectionView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"screenShot"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)ActionClose:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)completed:(BOOL)success
{
    if(tecExpert)
    {
        if(success)
        {
            QuickCheckResultViewController *touchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickCheckResultViewController"];
            [self.navigationController pushViewController:touchViewController animated:YES];
        }
    }
    if(success)
    {
        screenBool = success;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"screenTest"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [textCollectionView reloadData];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    imgScreen = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(imgScreen, 0.5);
    if(cameraSplit==4)
    {
        frontCamera = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"frontCamera"];
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"frontCameraImage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (cameraSplit==7)
    {
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"crackScreenImage"];
        screenCheckBool = YES;
        [[NSUserDefaults standardUserDefaults] synchronize];
        QuickCheckResultViewController *touchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickCheckResultViewController"];
        [self.navigationController pushViewController:touchViewController animated:YES];
    }
    else
    {
        backCamera = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"backCamera"];
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"backCameraImage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    [textCollectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

