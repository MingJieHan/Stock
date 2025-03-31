//
//  HansStackObject.h
//  stack
//
//  Created by jia yu on 2023/10/13.
//

#import <Foundation/Foundation.h>
#import "HansKObject.h"
#import "HansStockSuggestItem.h"

typedef void (^HansStock_Completion) (NSArray <HansKObject *>* _Nullable kArray);

//typedef NS_ENUM(NSInteger, KMinuteType) {
//    KMinuteType_5 = 5,
//    KMinuteType_15 = 15,
//    KMinuteType_30 = 30,
//    KMinuteType_60 = 60
//};


NS_ASSUME_NONNULL_BEGIN
@interface HansStockObject : NSObject
+(BOOL)getZhStock:(NSString *)num withType:(HansStockKType)type withLen:(NSInteger)len completion:(HansStock_Completion)completed;
+(BOOL)getUsStock:(NSString *)num withType:(HansStockKType)type withLen:(NSInteger)len completion:(HansStock_Completion)completed;
+(BOOL)getQiHuoStock:(NSString *)num withType:(HansStockKType)type completion:(HansStock_Completion)completed;
@end
NS_ASSUME_NONNULL_END
