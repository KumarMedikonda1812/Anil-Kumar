//
//  ProfileParallaxHeaderView.m
//  AMTrust
//
//  Created by kishore kumar on 31/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "ProfileParallaxHeaderView.h"

@implementation ProfileParallaxHeaderView
@synthesize imgProfile,editProfileButton;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ProfileParallaxHeaderView"
                                                          owner:self
                                                        options:nil];
        
        UIView* mainView = (UIView*)[nibViews objectAtIndex:0];
        
        mainView.frame = self.bounds;
        
        [self addSubview:mainView];
                
    }
    return self;
}


@end
