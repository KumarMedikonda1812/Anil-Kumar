//
//  QuickCheckValidationViewController.m
//  Tecprotec
//
//  Created by kishore kumar on 08/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "QuickCheckValidationViewController.h"

@interface QuickCheckValidationViewController ()

@end

@implementation QuickCheckValidationViewController
@synthesize progressBarLength;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    tenCount = 0.30;
    
    twoMinTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(timer)
                                                 userInfo:nil
                                                  repeats:YES];
    tenSeconds = 3;
    
    _lblGiveUsaMoment.text = NSLocalizedStringFromTableInBundle(@"Give us a moment, we’re doing further checks on your gadget.", nil, [[Helper sharedInstance] getLocalBundle], nil);

    
}
- (void)timer {
    
    tenSeconds--;
    
    tenCount += 0.20;
    
    progressBarLength.progress = tenCount;
    
    
    if (tenSeconds == 0 ) {
        
        QuickTestResultViewController *quickTestResultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickTestResultViewController"];
        [self.navigationController pushViewController:quickTestResultViewController animated:YES];

        
        [twoMinTimer invalidate];
    }
    
    NSLog(@" thme interval = %ld",(long)tenSeconds);
}

-(IBAction)QuickTestResultViewController:(id)sender
{
    QuickTestResultViewController *quickTestResultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickTestResultViewController"];
    [self.navigationController pushViewController:quickTestResultViewController animated:YES];
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

@end
