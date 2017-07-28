//
//  HistoryTableViewCell.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 14/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    self.VwBg.layer.cornerRadius = 6.0f;
    self.VwBg.layer.borderWidth = 1.0f;
    self.VwBg.layer.borderColor = [UIColor clearColor].CGColor;
    self.VwBg.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
