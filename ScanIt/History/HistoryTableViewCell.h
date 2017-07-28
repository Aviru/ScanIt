//
//  HistoryTableViewCell.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 14/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblProductName;

@property (weak, nonatomic) IBOutlet UIImageView *productImgVw;

@property (strong, nonatomic) IBOutlet UIView *VwBg;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;


@end
