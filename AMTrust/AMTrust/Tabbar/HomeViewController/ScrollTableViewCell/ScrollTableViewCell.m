//
//  ScrollTableViewCell.m
//  AMTrust
//
//  Created by kishore kumar on 02/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "ScrollTableViewCell.h"

#define CONTENT_ARRAY  [NSArray arrayWithObjects: @"Peace of Mind",@"Fast, Reliable Service",@"Protect your gadgets",@"Share with friends",nil]
#define IMAGE_ARRAY  [NSArray arrayWithObjects: @"Home-Banner-1", @"Home-Banner-2", @"Home-Banner-3",@"Home-Banner-4",nil]

@implementation ScrollTableViewCell
@synthesize imageScrollView;
@synthesize pageControl;
@synthesize contentLabel;


- (void)awakeFromNib {
    [super awakeFromNib];
    
    imageScrollView.delegate = self;
    [imageScrollView setPagingEnabled:YES];
    [imageScrollView setAlwaysBounceVertical:NO];

    pageControl.numberOfPages = CONTENT_ARRAY.count;
    pageControl.currentPage = 0;
}

-(void)createImageScroll
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = 250.0f;

    [imageScrollView setContentSize:CGSizeMake( width * [IMAGE_ARRAY count],height)];


    for (int i = 0; i < [IMAGE_ARRAY count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i *  width, 0, width, height)];
        [imageView setImage:[UIImage imageNamed:[IMAGE_ARRAY objectAtIndex:i]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [imageScrollView addSubview:imageView];
    }
    
    contentLabel.text =  NSLocalizedStringFromTableInBundle(@"Peace of Mind", nil, [[Helper sharedInstance] getLocalBundle], nil);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    [imageScrollView setContentOffset: CGPointMake(imageScrollView.contentOffset.x,0)];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    CGFloat pageWidth = screenWidth;
    int page = floor((imageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    contentLabel.text =  NSLocalizedStringFromTableInBundle([CONTENT_ARRAY objectAtIndex:page], nil, [[Helper sharedInstance] getLocalBundle], nil);

    pageControl.currentPage = page;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
