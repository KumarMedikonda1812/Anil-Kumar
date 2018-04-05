//
//  MyPlansViewController.m
//  AMTrust
//
//  Created by kishore kumar on 31/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "MyPlansViewController.h"

@interface MyPlansViewController ()

@end

@implementation MyPlansViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myPlansArray = [[NSMutableArray alloc] init];
    arrColorList = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Helper sharedInstance] trackingScreen:@"Myplan_IOS"];

    [self refresh];
}

-(void)refresh
{
    CommonRequest *commonRequest = [CommonRequest sharedInstance];
    commonRequest.delegate = self;
    
    [commonRequest getMyPlans];
}

- (void)colorCodeApi
{
    [SVProgressHUD showWithStatus:@"Loading.."];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://admin.tecprotec.co/api/plans" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *response = responseObject;

        arrColorList = [response objectForKey:@"plans"];

        [SVProgressHUD dismiss];

        [collectionViewPlans reloadData];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return myPlansArray.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyPlansCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imgLogo.tag = indexPath.row;

    if(indexPath.row == 0)
    {
        cell.addCellView.hidden = NO;
        cell.planCellView.hidden = YES;
        
        CAShapeLayer *yourViewBorder = [CAShapeLayer layer];
        yourViewBorder.strokeColor = [UIColor redColor].CGColor;
        yourViewBorder.fillColor = nil;
        yourViewBorder.lineDashPattern = @[@2, @2];
        yourViewBorder.frame = cell.contentView.bounds;
        yourViewBorder.path = [UIBezierPath bezierPathWithRect:cell.addCellView.bounds].CGPath;
        [cell.addCellView.layer addSublayer:yourViewBorder];
    }
    else
    {
        cell.addCellView.hidden = YES;
        cell.planCellView.hidden = NO;

        cell.imgLogo.contentMode = UIViewContentModeScaleAspectFit;
        
        NSDictionary *dict = [myPlansArray objectAtIndex:indexPath.row - 1];
        
        NSString *status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cf_1965"]];
        NSString *startDateStr = [dict objectForKey:@"cf_1297"];

        if([[Helper sharedInstance] checkForNull:status])
        {
            cell.lblProductName.text = @"NA";
        }else
        {
            if([status isEqualToString:@"POLICY-Current"])
            {
                NSDateFormatter *f = [[NSDateFormatter alloc] init];
                [f setDateFormat:@"yyyy-MM-dd"];
                
                NSDate *startDate = [f dateFromString:startDateStr];
                
                if(![self isPolicyLive:startDate])
                {
                    cell.lblProductName.text = @"POLICY-Renewal";
                }else
                {
                    cell.lblProductName.text = status;
                }
            }else
            {
                cell.lblProductName.text = status;
            }
        }
        
        NSString *productName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"productname"]];
        cell.lblName.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"productname"]];
        NSString * deviceCategory = [NSString stringWithFormat:@"%@",[dict objectForKey:@"device_category"]];
        NSString *imei = [NSString stringWithFormat:@"%@",[dict objectForKey:@"subject"]];
        cell.lblDetails.text = deviceCategory;
        cell.lblProductDetails.text = imei;
        
        NSString *imgUrl = [NSString stringWithFormat:@"%@",[[myPlansArray objectAtIndex:indexPath.row-1] objectForKey:@"imagename"]];
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"LogoNoText"]];
        
        cell.constraintsForAdd.priority = 250;
        
        NSString *colorCode;
        
        for (int i=0; i<arrColorList.count; i++) {
            
            NSString *productNameMobello = [NSString stringWithFormat:@"%@",[[arrColorList objectAtIndex:i] objectForKey:@"name"]];
            
            if([productNameMobello isEqualToString:productName])
            {
                colorCode = [[arrColorList objectAtIndex:i] objectForKey:@"colorCode"];
            }
        }
        
        if(colorCode.length==0){
            cell.planCellView.backgroundColor = [UIColor yellowColor];
        }else{
            cell.planCellView.backgroundColor = [Helper colorWithHexString:colorCode];
        }
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        [delegate showHomeScreen];
    }else{

        NSDictionary *dict = [myPlansArray objectAtIndex:indexPath.row-1];
        [delegate myPlanRedirection:dict withCategoryArray:myPlansArray];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (collectionView.frame.size.width/3) - 10;
    return CGSizeMake(width , 160);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5,5,5,5);
}

#pragma mark - Common Request API

-(void)commonRequestGetResponse:(NSDictionary *)response withAPIName:(NSString *)name
{
    if([name isEqualToString:@"getMyPlans"])
    {
        BOOL success = [[response objectForKey:@"success"] boolValue];
        
        if(success)
        {
            NSString *status=[NSString stringWithFormat:@"%@",[[response objectForKey:@"result"] objectForKey:@"status"]];
            
            if([status isEqualToString:@"failure"])
            {
                [myPlansArray removeAllObjects];
                        
            }else{
                
                NSDictionary *resultDict = [response objectForKey:@"result"];
                
                myPlansArray = [resultDict objectForKey:@"data"];
                myPlansArray = [[[myPlansArray reverseObjectEnumerator] allObjects] mutableCopy];
                
            }
            
            NSDictionary *dicPersonal = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
            
            if(dicPersonal.count!=0)
            {
                [self colorCodeApi];
            }
            
            [SVProgressHUD dismiss];
        }
    }
}

- (BOOL)isPolicyLive:(NSDate *)startDate{
    
    BOOL isPolicyLive = NO;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *remainingDays = [gregorianCalendar components:NSCalendarUnitDay
                                                           fromDate:[NSDate date]
                                                             toDate:startDate
                                                            options:0];
    
    NSInteger remainDays = [remainingDays day];
    
    if(remainDays <= 0)
    {
        isPolicyLive = YES;
    }
    
    return isPolicyLive;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
