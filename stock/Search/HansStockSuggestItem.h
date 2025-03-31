//
//  HansStockSuggestItem.h
//  stack
//
//  Created by jia yu on 2023/10/15.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, StockFrom) {
    StockFrom_HK = 31,
    StockFrom_ZH = 11,
    StockFrom_US = 41,
    StockFrom_HUNHE = 21,
    StockFrom_QIHUO = 87,
    StockFrom_HUNHE1 = 201,
    StockFrom_ZHAIQUAN = 81,
    StockFrom_ZHISHU = 86,
    StockFrom_Unknown = 103,
    StockFrom_ZHISHU1 = 33
};


typedef NS_ENUM(NSInteger, HansStockKType) {
    HansStockKType_5 = 5,       //Default
    HansStockKType_15 = 15,
    HansStockKType_30 = 30,
    HansStockKType_60 = 60
};

NS_ASSUME_NONNULL_BEGIN
@interface HansStockSuggestItem : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *code;
@property (nonatomic) NSString *search_code;
@property (nonatomic) StockFrom from;
@property (nonatomic) HansStockKType type;

-(id)init NS_UNAVAILABLE;
-(id)initWithString:(NSString *)str;

+(NSString *)nameForType:(HansStockKType)type;

-(id)initWithSaveString:(NSString *)savedString;
-(NSString *)saveString;
@end
NS_ASSUME_NONNULL_END
