//
//  TipsHeaderCollectionReusableView.h
//  TecProtec
//
//  Created by kishore kumar on 13/09/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsHeaderCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *btnDeviceHealth;
@property (weak, nonatomic) IBOutlet UILabel *lblHealthCheck;
@property (weak, nonatomic) IBOutlet UILabel *lblTipsForYou;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblHeightConstraints;

@end
