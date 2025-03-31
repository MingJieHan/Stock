//
//  HansStockSuggestItem.m
//  stack
//
//  Created by jia yu on 2023/10/15.
//

#import "HansStockSuggestItem.h"
@implementation HansStockSuggestItem
@synthesize name,search_code,code;
@synthesize from;
@synthesize type;

-(id)initWithString:(NSString *)str{
    self = [super init];
    if (self){
        NSArray *array = [str componentsSeparatedByString:@","];
        if (10 != array.count){
            return nil;
        }
        name = [array objectAtIndex:0];
        from = [[array objectAtIndex:1] integerValue];
        switch (from) {
            case StockFrom_HK:
                break;
            case StockFrom_US:
                break;
            case StockFrom_ZH:
                break;
            case StockFrom_QIHUO:
                break;
            case StockFrom_ZHAIQUAN:
                return nil;
            case StockFrom_ZHISHU:
                return nil;
            case StockFrom_ZHISHU1:
                return nil;
            case StockFrom_Unknown:
                return nil;
            case StockFrom_HUNHE:
                return nil;
            case StockFrom_HUNHE1:
                return nil;
            default:
                NSLog(@"need add from.");
                break;
        }
        code = [array objectAtIndex:2];
        search_code = [array objectAtIndex:3];
        
        //容错 bj838924
        if ([name isEqualToString:search_code]){
            NSString *str4 = [array objectAtIndex:4];
            if (str4 && str4.length > 0){
                name = str4;
            }
        }
//        [array objectAtIndex:7];  99 中国石化
//        [array objectAtIndex:8];  1
//        [array objectAtIndex:9];  ESG
//        NSLog(@"%@", array);
    }
    return self;
}

+(NSString *)nameForType:(HansStockKType)type{
    switch (type) {
        case HansStockKType_5:
            return @"5m";
        case HansStockKType_15:
            return @"15m";
        case HansStockKType_30:
            return @"30m";
        case HansStockKType_60:
            return @"60m";
        default:
            break;
    }
    return @"";
}

-(id)initWithSaveString:(NSString *)savedString{
    self = [super init];
    if (self){
        NSArray *array = [savedString componentsSeparatedByString:@"|"];
        if (array.count != 5){
            return nil;
        }
        name = [array objectAtIndex:0];
        search_code = [array objectAtIndex:1];
        code = [array objectAtIndex:2];
        from = [[array objectAtIndex:3] integerValue];
        type = [[array objectAtIndex:4] integerValue];
    }
    return self;
}

-(NSString *)saveString{
    NSString *res = [NSString stringWithFormat:@"%@|%@|%@|%ld|%ld", name, search_code, code, from, type];
    return res;
}

@end
