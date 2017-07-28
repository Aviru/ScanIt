//
//  PurchaseTableViewCell.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 15/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblProductName;

@property (weak, nonatomic) IBOutlet UILabel *lblProductInvoice;

@property (weak, nonatomic) IBOutlet UIImageView *scanItImgVw;

@end

