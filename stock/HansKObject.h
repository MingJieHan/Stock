//
//  HansKObject.h
//  stack
//
//  Created by jia yu on 2023/10/13.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KObjectActionType) {
    KObjectActionType_Buy = 2,
    KObjectActionType_Saled = 1,
    KObjectActionType_Normal = 0
};

NS_ASSUME_NONNULL_BEGIN
@interface HansKObject : NSObject
@property (nonatomic) NSString *dayTime;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger hour;
@property (nonatomic) NSInteger minute;

@property (nonatomic) float open;
@property (nonatomic) float close;
@property (nonatomic) float high;
@property (nonatomic) float low;
@property (nonatomic) float ma_price;
@property (nonatomic) NSInteger ma_volume;
@property (nonatomic) NSInteger volume;

@property (nonatomic) float average5;
@property (nonatomic) float average10;
@property (nonatomic) float average20;
@property (nonatomic) float average30;

@property (nonatomic) KObjectActionType type;
@property (nonatomic) float cash;
@property (nonatomic) float stock;

-(id)init NS_UNAVAILABLE;
-(id)initZhWithDictionary:(NSDictionary *)dict;
-(id)initUSWithDictionary:(NSDictionary *)dict;
-(id)initWithMinuteLine:(NSString *)line;   //分时线

-(float)price;
-(int)timeFrom1970;
-(NSDate *)date;

+(NSArray <HansKObject *>*)kObjectsFromZhAPI:(NSArray <NSDictionary *>*)array;
+(NSArray <HansKObject *>*)kObjectsFromWebAPI:(NSString *)html;
+(NSArray *)kObjectFromFenshi:(NSString *)html;

+(float)average:(NSArray <NSNumber *>*)array;
@end
NS_ASSUME_NONNULL_END
