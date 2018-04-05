//
//  PlansTableViewCell.h
//  AMTrust
//
//  Created by kishore kumar on 05/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLProgressBar.h"

@interface PlansTableViewCell : UITableViewCell
{
    NSArray *contentArray;
    BOOL isPolicyLive;
}
@property (weak, nonatomic) IBOutlet UILabel *planLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet YLProgressBar *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *renewButton;

-(void)updateContent:(NSDictionary *)dict withContentArray:(NSArray *)contentArray;

@end
