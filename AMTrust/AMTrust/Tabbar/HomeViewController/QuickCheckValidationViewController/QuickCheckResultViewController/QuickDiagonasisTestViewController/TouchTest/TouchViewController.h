//
//  TouchViewController.h
//  AMS
//
//  Created by Sethu on 23/6/16.
//  Copyright © 2016 amtrust. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TouchDelegate;

@interface TouchViewController : UIViewController
{
    int totalCount;
    int totalRow;
    int totalColumn;
    float width;
    float height;
    
    NSMutableArray *viewArray;
    
    NSTimer *timerSeconds;
    NSInteger timer;

}

@property (nonatomic, weak) id<TouchDelegate> delegate;

@end

@protocol TouchDelegate <NSObject>

@optional
-(void)completed:(BOOL)success;

@end
