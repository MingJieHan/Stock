//
//  HansStockSearchResultTableViewController.h
//  stack
//
//  Created by jia yu on 2023/10/15.
//

#import <UIKit/UIKit.h>
#import "HansStockSuggestItem.h"

NS_ASSUME_NONNULL_BEGIN
@interface HansStockSearchResultTableViewController : UITableViewController
@property (nonatomic) NSArray <HansStockSuggestItem *>*results;
@end
NS_ASSUME_NONNULL_END
