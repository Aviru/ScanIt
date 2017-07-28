//
//  ProductOptionCollectionViewCell.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 25/05/17.
//  Copyright © 2017 Aviru bhattacharjee. All rights reserved.
//

#import "ProductOptionCollectionViewCell.h"

@implementation ProductOptionCollectionViewCell

-(void)awakeFromNib
{
    self.imgVwProductSearchType.layer.cornerRadius = 4.0f;
    
    /*
    self.contentView.layer.cornerRadius = 2.0f;
    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    self.contentView.layer.masksToBounds = YES;
    
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 1.0f;
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
     */
}



@end
