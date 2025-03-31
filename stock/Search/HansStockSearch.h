//
//  HansStockSearch.h
//  stack
//
//  Created by jia yu on 2023/10/15.
//

#import <Foundation/Foundation.h>
#import "HansStockSuggestItem.h"

typedef void (^HansStockSearch_Completion) (NSArray <HansStockSuggestItem *>* _Nullable suggestions);

NS_ASSUME_NONNULL_BEGIN
@interface HansStockSearch : NSObject
+(BOOL)searchWord:(NSString *)word completion:(HansStockSearch_Completion)completion;
@end
NS_ASSUME_NONNULL_END
