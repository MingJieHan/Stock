//
//  HansStockHistory.m
//  Stock
//
//  Created by jia yu on 2023/10/21.
//

#import "HansStockHistory.h"
static NSMutableString *historyString;
@interface HansStockHistory(){
    
}
@end

@implementation HansStockHistory
+(NSMutableArray <HansStockSuggestItem *>*)loadHistorys{
    NSMutableArray <HansStockSuggestItem *>*results = [[NSMutableArray alloc] init];
    historyString = [[NSMutableString alloc] init];
    NSString *abc = [NSUserDefaults.standardUserDefaults valueForKey:@"History"];
    if ( abc && abc.length > 0){
        [historyString appendString:abc];
    }else{
        NSString *file = [NSBundle.mainBundle pathForResource:@"default" ofType:@"md"];
        NSString *str = [[NSString alloc] initWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
        [historyString appendString:str];
    }
    NSArray *array = [historyString componentsSeparatedByString:@"\n"];
    for (NSString *str in array){
        HansStockSuggestItem *item = [[HansStockSuggestItem alloc] initWithSaveString:str];
        if (item){
            [results addObject:item];
        }
    }
    return results;
}

+(void)addFavorite:(HansStockSuggestItem *)item{
    if (nil == historyString){
        historyString = [[NSMutableString alloc] init];
    }
    if (historyString && historyString.length>3){
        [historyString appendString:@"\n"];
    }
    [historyString appendString:[item saveString]];
    [NSUserDefaults.standardUserDefaults setValue:historyString forKey:@"History"];
    [NSUserDefaults.standardUserDefaults synchronize];
    return;
}

+(void)removeFavorite:(HansStockSuggestItem *)item{
    NSString *abc = [NSUserDefaults.standardUserDefaults valueForKey:@"History"];
    NSArray *array = [abc componentsSeparatedByString:@"\n"];
    historyString = [[NSMutableString alloc] init];
    for (NSString *str in array){
        if ([str rangeOfString:item.search_code].length > 0){
            continue;
        }
        if (historyString.length > 0){
            [historyString appendString:@"\n"];
        }
        [historyString appendString:str];
    }
    [NSUserDefaults.standardUserDefaults setValue:historyString forKey:@"History"];
    [NSUserDefaults.standardUserDefaults synchronize];
    return;
}
@end
