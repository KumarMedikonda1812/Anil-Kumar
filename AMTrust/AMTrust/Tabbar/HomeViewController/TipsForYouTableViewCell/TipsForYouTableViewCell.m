//
//  TipsForYouTableViewCell.m
//  AMTrust
//
//  Created by kishore kumar on 05/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "TipsForYouTableViewCell.h"

@implementation TipsForYouTableViewCell
@synthesize arrTips;
@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UINib *tipsNib = [UINib nibWithNibName:@"TipsCollectionViewCell" bundle:nil];
    [tipsCollectionView registerNib:tipsNib forCellWithReuseIdentifier:@"TipsCollectionViewCell"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(arrTips.count > 4)
        return 4;
    else
        return arrTips.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TipsCollectionViewCell" forIndexPath:indexPath];
    
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",BASEIMAGEURL,[[arrTips objectAtIndex:indexPath.row] objectForKey:@"imagename"]];
    [cell.tipsImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    NSString *question = [[arrTips objectAtIndex:indexPath.row] objectForKey:@"question"];
    question = [question stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    cell.tipsLblDetails.text = [NSString stringWithFormat:@"%@",question];;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self returnTipsDetail:indexPath.row];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = collectionView.frame.size.width;
    return CGSizeMake(screenWidth/2-40,200);
}

-(void)returnTipsDetail:(NSUInteger )number
{
    [delegate returnTipsDetail:number];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
