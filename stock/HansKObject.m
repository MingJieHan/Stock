//
//  HansKObject.m
//  stack
//
//  Created by jia yu on 2023/10/13.
//

#import "HansKObject.h"

@implementation HansKObject
@synthesize open,close;
@synthesize high,low;
@synthesize ma_price,ma_volume;
@synthesize volume;
@synthesize dayTime;
@synthesize year,month,day,hour,minute;
@synthesize average5,average10,average20,average30;
@synthesize type,cash,stock;

-(id)initZhWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self){
        type = KObjectActionType_Normal;
        dayTime = [dict valueForKey:@"day"];
        if (nil == dayTime || dayTime.length < 19){
            NSLog(@"DayTime error.");
            return nil;
        }
        sscanf([dayTime UTF8String], "%4ld-%2ld-%2ld %2ld:%2ld:00", &year, &month, &day, &hour, &minute);
        open = [[dict valueForKey:@"open"] floatValue];
        close = [[dict valueForKey:@"close"] floatValue];
        high = [[dict valueForKey:@"high"] floatValue];
        low = [[dict valueForKey:@"low"] floatValue];
        ma_price = [[dict valueForKey:@"ma_price5"] floatValue];
        ma_volume = [[dict valueForKey:@"ma_volume5"] integerValue];
        volume = [[dict valueForKey:@"volume"] integerValue];
    }
    return self;
}
-(id)initUSWithDictionary:(NSDictionary *)dict{
    if (nil == dict){
        return nil;
    }
    self = [super init];
    if (self){
        type = KObjectActionType_Normal;
        dayTime = [dict valueForKey:@"d"];  //2023-09-06 10:05:00
        if (nil == dayTime || dayTime.length < 19){
            NSLog(@"DayTime error.");
            return nil;
        }
        sscanf([dayTime UTF8String], "%4ld-%2ld-%2ld %2ld:%2ld:00", &year, &month, &day, &hour, &minute);
        open = [[dict valueForKey:@"o"] floatValue];
        close = [[dict valueForKey:@"c"] floatValue];
        high = [[dict valueForKey:@"h"] floatValue];
        low = [[dict valueForKey:@"l"] floatValue];
        ma_volume = [[dict valueForKey:@"a"] integerValue];
        volume = [[dict valueForKey:@"v"] integerValue];
    }
    return self;
}

-(id)initWithMinuteLine:(NSString *)line{
    self = [super init];
    if (self){
        NSArray *array = [line componentsSeparatedByString:@","];
        if (7 != array.count){
            NSLog(@"ddd");
        }
    }
    return self;
}

-(float)price{
    return (open+close)/2.f;
}

-(int)timeFrom1970{
    return [[self date] timeIntervalSince1970];
}

-(NSDate *)date{
    NSDateComponents *com = [[NSDateComponents alloc] init];
    [com setCalendar:[NSCalendar currentCalendar]];
    [com setTimeZone:NSTimeZone.systemTimeZone];
    com.year = year;
    com.month = month;
    com.day = day;
    com.hour = hour;
    com.minute = minute;
    com.second = 0;
    return [com date];
}

+(NSArray <HansKObject *>*)kObjectsFromZhAPI:(NSArray <NSDictionary *>*)array{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array){
        HansKObject *k = [[HansKObject alloc] initZhWithDictionary:dict];
        [resultArray addObject:k];
    }
    return resultArray;
}

+(NSArray <HansKObject *>*)kObjectsFromWebAPI:(NSString *)html{
    NSRange range = [html rangeOfString:@"["];
    if (0 == range.location){
        return nil;
    }
    NSString *info = [html substringFromIndex:range.location];
    info = [info stringByReplacingOccurrencesOfString:@");" withString:@""];
    NSData *jsonData = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&jsonError];
    if (jsonError){
        NSLog(@"Json Error:%@", jsonError);
        return nil;
    }
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (NSDictionary *line in array){
        HansKObject *o = [[HansKObject alloc] initUSWithDictionary:line];
        if (o){
            [resultArray addObject:o];
        }
    }
    return resultArray;
}


+(NSArray *)kObjectFromFenshi:(NSString *)html{
    // <script>location.href='//sina.com';</script>*/
    //var t1nf_P0=([["21:00","7296.000","7308.568","18972","440802","7272.000","2023-10-16"],["21:01","7
    NSRange range = [html rangeOfString:@"=([["];
    if (0 == range.location){
        return nil;
    }
    NSString *info = [html substringFromIndex:range.location+range.length];
    NSArray *array = [info componentsSeparatedByString:@"],["];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (NSString *line in array){
        HansKObject *o = [[HansKObject alloc] initWithMinuteLine:line];
        if (o){
            [resultArray addObject:o];
        }
    }
    return resultArray;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"Open:%.2f Close:%.2f High:%.2f Low:%.2f", open, close, high, low];
}

+(float)average:(NSArray <NSNumber *>*)array{
    float total = 0.f;
    for (NSNumber *n in array){
        total += [n floatValue];
    }
    return total/array.count;
}
@end
