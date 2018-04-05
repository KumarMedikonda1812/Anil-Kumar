//
//  TextTableViewCell.h
//  TecProtec
//
//  Created by kishore kumar on 31/08/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

-(void)updateText:(NSString *)textStr;

@end
