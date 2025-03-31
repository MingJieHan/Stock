//
//  SettingsTableViewController.h
//  stock
//
//  Created by jia yu on 2023/10/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface SettingsTableViewController : UITableViewController
+(SettingsTableViewController *)shared;

-(float)testCashValue;

//股票卖出时支付
-(float)stampDuty:(float)gottedCash;

//证管费+交易经手费, 买卖都要收取
-(float)securitiesManagementFees:(float)value;

//佣金， 买卖双向收取
-(float)commissionFees:(float)value;

-(float)allFeesFor:(float)value isSaled:(BOOL)sale;
@end
NS_ASSUME_NONNULL_END
