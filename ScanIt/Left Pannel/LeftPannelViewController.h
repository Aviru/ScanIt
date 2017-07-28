//
//  LeftPannelViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 02/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftPannelViewController : superViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *leftPannelTableVw;

@property (weak, nonatomic) IBOutlet UIImageView *profileImgVw;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;


@end
