//
//  HistoryViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 03/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *historyTableContainingView;

@property (weak, nonatomic) IBOutlet UITableView *historyTableVw;

@property (weak, nonatomic) IBOutlet UIButton *clearAllBtnOutletr;

@property (strong, nonatomic) IBOutlet UIButton *leftPannelBtnOutlet;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;



- (IBAction)clearAllAction:(id)sender;

//typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);

typedef void (^ALAssetsLibraryWriteImageCompletionBlock)(NSURL *assetURL, NSError *error);
typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

@end
