//
//  HansStockViewController.h
//  stack
//
//  Created by jia yu on 2023/10/15.
//

#import <UIKit/UIKit.h>
#import "HansStockSuggestItem.h"
#define DefaultCash 1000000.f
#define DefaultStock 0.f


NS_ASSUME_NONNULL_BEGIN
@interface HansStockViewController : UIViewController
@property (nonatomic) HansStockSuggestItem *item;
@end
NS_ASSUME_NONNULL_END
