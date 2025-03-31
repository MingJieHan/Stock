//
//  HansStockHistory.h
//  Stock
//
//  Created by jia yu on 2023/10/21.
//

#import <Foundation/Foundation.h>
#import "HansStockSuggestItem.h"

NS_ASSUME_NONNULL_BEGIN
@interface HansStockHistory : NSObject
+(NSMutableArray <HansStockSuggestItem *>*)loadHistorys;

+(void)addFavorite:(HansStockSuggestItem *)item;
+(void)removeFavorite:(HansStockSuggestItem *)item;
@end
NS_ASSUME_NONNULL_END
