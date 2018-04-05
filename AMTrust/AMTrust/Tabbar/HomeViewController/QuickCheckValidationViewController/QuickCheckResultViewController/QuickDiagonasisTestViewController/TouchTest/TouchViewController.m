//
//  TouchViewController.m
//  AMS
//
//  Created by Sethu on 23/6/16.
//  Copyright © 2016 amtrust. All rights reserved.
//

#import "TouchViewController.h"

@interface TouchViewController ()

@end

@implementation TouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewArray = [[NSMutableArray alloc] init];
    
    totalCount = 0;
    
    totalRow = 5;
    totalColumn = 10;
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    width = self.view.frame.size.width/totalRow;
    height = self.view.frame.size.height/totalColumn;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackMore"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(backitem:)];
    backButton.tintColor = [Helper colorWithHexString:@"#FF304B"];

    self.navigationItem.leftBarButtonItem = backButton;
    
    for(int row = 0;row <= totalRow;row++)
    {
        for(int column = 0;column <= totalColumn; column++)
        {
            UIView *button = [[UIView alloc] init];
            button.frame = CGRectMake(width * row, height*column, width, height);
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.borderWidth = 0.5f;
            button.userInteractionEnabled = YES;
            button.tag = row *10 + column;
            button.backgroundColor = [UIColor whiteColor];

            [self.view addSubview:button];
            
            [viewArray addObject:button];
        }
    }

   timerSeconds = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(timer)
                                   userInfo:nil
                                    repeats:YES];
    
    timer = 10;
    
    
}

-(void)timer {
    timer--;
    
    if(timer==0)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [_delegate completed:NO];
        }];
    }
}
-(IBAction)backitem:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [_delegate completed:NO];
    }];}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(IBAction)selectedAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if( button.backgroundColor == [UIColor whiteColor])
    {
        button.backgroundColor = THEMECOLOR;
        
        totalCount++;
        
        if(totalCount == totalRow * totalColumn)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [_delegate completed:true];
            }];
        }

    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint firstTouch = [touch locationInView:self.view];

    for (UIView *view in viewArray) {
        if (CGRectContainsPoint(view.frame, firstTouch)) {
            
            if(view.backgroundColor == [UIColor whiteColor])
            {
                view.backgroundColor = THEMECOLOR;

                totalCount++;
                
                if(totalCount == totalRow * totalColumn)
                {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [_delegate completed:true];
                    }];
                   // [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }    
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
