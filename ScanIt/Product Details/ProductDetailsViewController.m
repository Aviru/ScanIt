//
//  ProductDetailsViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 12/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "ProductDetailsViewController.h"

@interface ProductDetailsViewController ()<UITextFieldDelegate>

@end

@implementation ProductDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.purchaseBtnOutlet.layer.cornerRadius = 3.0f;
    
    NSArray *arrkeys;
    
    for (NSDictionary *currentDictionary in _arrSelectedProductDetails)
    {
        arrkeys = [currentDictionary allKeys];
    }
    
    _lblSelectedProductName.text = [[_arrSelectedProductDetails objectAtIndex:0] objectForKey:@"title"];
    
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[_arrSelectedProductDetails objectAtIndex:0] objectForKey:@"ImageURL"]]];
    
    _selectedProductImgVw.image = [UIImage imageWithData:imgData scale:0.5];
    
    _lblPrice.text = [[[[_arrSelectedProductDetails objectAtIndex:0] objectForKey:@"currency"] stringByAppendingString:@" "] stringByAppendingString:[NSString stringWithFormat:@"%@",[[_arrSelectedProductDetails objectAtIndex:0] objectForKey:@"amount"]]];
    
    _lblBrandName.text = [[_arrSelectedProductDetails objectAtIndex:0] objectForKey:@"productBrand"];
    
    if ([arrkeys containsObject:@"productDescription"])
    {
        if (![[[_arrSelectedProductDetails objectAtIndex:0] objectForKey:@"productDescription"] isEqualToString:@""])
        {
            CGSize textSize = [self messageSize:[[_arrSelectedProductDetails objectAtIndex:0] objectForKey:@"productDescription"]];
            
            _lblProductDesc.frame = CGRectMake(_lblProductDesc.frame.origin.x, _lblProductDesc.frame.origin.y, _lblProductDesc.frame.size.width, textSize.height + 2);
            
            _lblProductDesc.text = [[_arrSelectedProductDetails objectAtIndex:0] objectForKey:@"productDescription"];
            
            _lblPrice.center = CGPointMake(_lblPrice.frame.origin.x+(_lblPrice.frame.size.width/2),textSize.height + (_lblPrice.frame.size.height/2) + _lblProductDesc.frame.origin.y); //_lblProductDesc.frame.origin.x  +(_lblPrice.frame.size.height/2) 40 +
            
            _lblNamePrice.center =CGPointMake(_lblNamePrice.frame.origin.x+(_lblNamePrice.frame.size.width/2), textSize.height +  (_lblNamePrice.frame.size.height/2) +_lblProductDesc.frame.origin.y);//_lblProductDesc.frame.origin.x+textSize.height + 40 +
            
            _purchaseBtnOutlet.center=CGPointMake(_purchaseBtnOutlet.frame.origin.x+(_purchaseBtnOutlet.frame.size.width/2),  _lblNamePrice.frame.origin.y + 40);//_lblProductDesc.frame.origin.x  +(_purchaseBtnOutlet.frame.size.height/2) 40 +
            
        }
        
    }
    else
    {
        _lblPrice.hidden = YES;
    }
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollVw.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollVw.contentSize = contentRect.size;
    
}

#pragma mark - Text Size

- (CGSize)messageSize:(NSString *)message
{
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:message
                                                                         attributes:@{
                                          NSFontAttributeName: [UIFont fontWithName:@"Arial" size:14.0]
                                          }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){292, 9999}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil]; // 292
    
    CGSize size = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
    
    return size;
}
#pragma mark

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"_purchaseBtnOutlet.frame:%@",_purchaseBtnOutlet);
    NSLog(@"_lblNamePrice.frame:%@",_lblNamePrice);
    NSLog(@"_scrollVw.frame:%@",_scrollVw);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backToProductListAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)purchaseAction:(id)sender
{
    NSURL *url = [NSURL URLWithString:[[_arrSelectedProductDetails objectAtIndex:0] objectForKey:@"productUrl"]];
    [[UIApplication sharedApplication] openURL:url];
}
@end
