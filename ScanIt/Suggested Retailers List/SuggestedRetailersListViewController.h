//
//  SuggestedRetailersListViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 08/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestedRetailersListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *retailersListTableVw;

@property (weak, nonatomic) IBOutlet UILabel *lblMeesage;


- (IBAction)backToProductOptionsAction:(id)sender;

@property(nonatomic,strong)NSString *productName;

@end
