//
//  WhatsNewTableViewCell.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 26/11/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhatsNewTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblProductCategoryName;

@property (strong, nonatomic) IBOutlet UIImageView *imgVwProduct;

@property (strong, nonatomic) IBOutlet UIView *containerVw;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@end
