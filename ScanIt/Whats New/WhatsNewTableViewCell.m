//
//  WhatsNewTableViewCell.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 26/11/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "WhatsNewTableViewCell.h"

@implementation WhatsNewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.containerVw.layer.cornerRadius = 6.0f;
    self.containerVw.layer.borderWidth = 1.0f;
    self.containerVw.layer.borderColor = [UIColor clearColor].CGColor;
    self.containerVw.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
