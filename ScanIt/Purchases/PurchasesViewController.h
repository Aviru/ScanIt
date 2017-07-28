//
//  PurchasesViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 03/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchasesViewController : superViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *purchaseTableView;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;


@property (strong, nonatomic) IBOutlet UIButton *leftPannelBtnOutlet;

@end
