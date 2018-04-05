//
//  SplashViewController.h
//  TECPROTEC
//
//  Created by Sethu on 6/3/18.
//  Copyright © 2018 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonRequest.h"

@interface SplashViewController : UIViewController<CommonRequestDelegate>
{
    IBOutlet UIActivityIndicatorView *activityView;
    
}
    
@property(nonatomic) BOOL isFromBackground;
    
@end
