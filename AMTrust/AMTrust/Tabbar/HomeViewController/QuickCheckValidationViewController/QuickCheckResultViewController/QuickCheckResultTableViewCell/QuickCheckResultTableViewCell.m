//
//  QuickCheckResultTableViewCell.m
//  Tecprotec
//
//  Created by kishore kumar on 09/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "QuickCheckResultTableViewCell.h"

@implementation QuickCheckResultTableViewCell
@synthesize loadingView;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    spinner = [[DRPLoadingSpinner alloc] init];
    [loadingView addSubview:spinner];
    [spinner startAnimating];
    
    

    self.backgroundColor = [UIColor clearColor];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                          selector:@selector(timer:)
                                                 userInfo:nil
                                                  repeats:YES];
    number =3;
    
    
    
    
    
}
- (void)timer:(NSTimer *)timer{
    
    number--;
    
    
    
    if (number == 0 ) {
        

        
        loadingView.hidden = YES;
        [timer invalidate];
    }
    }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
