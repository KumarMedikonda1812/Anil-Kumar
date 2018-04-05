//
//  ContactHeaderTableViewCell.h
//  Tecprotec
//
//  Created by kishore kumar on 13/06/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLExpandableTableView.h"

@interface ContactHeaderTableViewCell : UITableViewCell <UIExpandingTableViewCell>

@property (nonatomic, assign, getter = isLoading) BOOL loading;

@property (nonatomic, readonly) UIExpansionStyle expansionStyle;

- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated;

@property (weak, nonatomic) IBOutlet UILabel *lblQuestions;
@property (weak, nonatomic) IBOutlet UIImageView *imgExpandColapse;

@end
