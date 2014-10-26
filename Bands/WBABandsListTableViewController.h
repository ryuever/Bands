//
//  WBABandsListTableViewController.h
//  Bands
//
//  Created by ryu on 2014/10/13.
//  Copyright (c) 2014年 ryu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBABand, WBABandDetailsViewController;

@interface WBABandsListTableViewController : UITableViewController
@property (nonatomic, strong)NSMutableDictionary *bandsDictionary;
@property (nonatomic, strong)NSMutableArray *firstLettersArray;
@property (nonatomic, strong)WBABandDetailsViewController *bandInfoViewController;

- (void)addNewBand:(WBABand *)WBABand;
- (void)saveBandsDictionary;
- (void)loadBandsDictionary;
- (void)deleteBandAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateBandObject:(WBABand *)bandObject atIndexPath:(NSIndexPath *)indexPath;
- (IBAction)addBandTouched:(id)sender;

@end
