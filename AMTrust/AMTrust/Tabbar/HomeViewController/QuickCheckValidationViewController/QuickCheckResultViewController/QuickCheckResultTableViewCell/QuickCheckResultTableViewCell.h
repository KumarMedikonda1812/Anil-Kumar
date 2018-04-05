//
//  QuickCheckResultTableViewCell.h
//  Tecprotec
//
//  Created by kishore kumar on 09/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "DRPLoadingSpinner.h"
@interface QuickCheckResultTableViewCell : UITableViewCell
{
    NSInteger number;
    DRPLoadingSpinner *spinner;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgActivityLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnDisclosure;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@end
