//
//  LikesViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 03/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *likeView;

@property (weak, nonatomic) IBOutlet UITableView *likeTableView;

@property (weak, nonatomic) IBOutlet UIButton *clearAllBtnOutlet;

@property (strong, nonatomic) IBOutlet UIButton *leftPannelBtnOutlet;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;


- (IBAction)clearAllAction:(id)sender;

@end
