//
//  HansStackObject.m
//  stack
//
//  Created by jia yu on 2023/10/13.
//

#import "HansStockObject.h"


@implementation HansStockObject
//加入5， 10 20 30 均线数值
+(void)addAverageValues:(NSArray <HansKObject *>*)kArray{
    NSMutableArray *average5 = [[NSMutableArray alloc] init];
    NSMutableArray *average10 = [[NSMutableArray alloc] init];
    NSMutableArray *average20 = [[NSMutableArray alloc] init];
    NSMutableArray *average30 = [[NSMutableArray alloc] init];
    for (HansKObject *o in kArray){
        [average5 addObject:[NSNumber numberWithFloat:o.close]];
        if (average5.count > 5){
            [average5 removeObjectAtIndex:0];
        }
        [average10 addObject:[NSNumber numberWithFloat:o.close]];
        if (average10.count > 10){
            [average10 removeObjectAtIndex:0];
        }
        [average20 addObject:[NSNumber numberWithFloat:o.close]];
        if (average20.count > 20){
            [average20 removeObjectAtIndex:0];
        }
        [average30 addObject:[NSNumber numberWithFloat:o.close]];
        if (average30.count > 30){
            [average30 removeObjectAtIndex:0];
        }
        o.average5 = [HansKObject average:average5];
        o.average10 = [HansKObject average:average10];
        o.average20 = [HansKObject average:average20];
        o.average30 = [HansKObject average:average30];
    }
    return;
}

/*
 http://money.finance.sina.com.cn/quotes_service/api/json_v2.php/CN_MarketData.getKLineData?symbol=sz000001&scale=5&ma=5&datalen=1023
 https://money.finance.sina.com.cn/quotes_service/api/json_v2.php/CN_MarketData.getKLineData?symbol=sh601857&scale=5&ma=5&datalen=10
 */

+(BOOL)getZhStock:(NSString *)num withType:(HansStockKType)type withLen:(NSInteger)len completion:(HansStock_Completion)completed{
    NSString *u = [NSString stringWithFormat:@"https://money.finance.sina.com.cn/quotes_service/api/json_v2.php/CN_MarketData.getKLineData?symbol=%@&scale=%d&ma=%d&datalen=%d", num, (int)type, (int)type, (int)len];
    NSURL *url = [[NSURL alloc] initWithString:u];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.f];
    NSURLSessionTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError = nil;
        NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        if (jsonError){
            NSLog(@"Json Error.");
            dispatch_async(dispatch_get_main_queue(), ^{
                completed(nil);
            });
            return;
        }
        if ([resultArray isKindOfClass:[NSNull class]]){
            NSLog(@"get error.");
            dispatch_async(dispatch_get_main_queue(), ^{
                completed(nil);
            });
            return;
        }
        
        NSArray *kArray = [HansKObject kObjectsFromZhAPI:resultArray];
        [HansStockObject addAverageValues:kArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(kArray);
        });
        return;
    }];
    [task resume];
    return YES;
}


/*
 美股
 https://stock.finance.sina.com.cn/usstock/api/jsonp_v2.php/var%20_WMT_5_1697326496804=/US_MinKService.getMinK?symbol=WMT&type=5&___qn=3
 */
+(BOOL)getUsStock:(NSString *)num withType:(HansStockKType)type withLen:(NSInteger)len completion:(HansStock_Completion)completed{
    NSString *u = [NSString stringWithFormat:@"https://stock.finance.sina.com.cn/usstock/api/jsonp_v2.php/var%%20_%@_%d_%ld=/US_MinKService.getMinK?symbol=%@&type=%d&___qn=3",
                   num, (int)type, time(0), num, (int)type];
    NSURL *url = [[NSURL alloc] initWithString:u];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.f];
    NSURLSessionTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (nil != error){
            dispatch_async(dispatch_get_main_queue(), ^{
                completed(nil);
            });
            return;
        }
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (nil == html){
            dispatch_async(dispatch_get_main_queue(), ^{
                completed(nil);
            });
            return;
        }
        NSArray *kArray = [HansKObject kObjectsFromWebAPI:html];
        [HansStockObject addAverageValues:kArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(kArray);
        });
        return;
    }];
    [task resume];
    return YES;
}

/*
 P0  P2401
@"https://stock2.finance.sina.com.cn/futures/api/jsonp.php/var%20t1nf_P0=/InnerFuturesNewService.getMinLine?symbol=P0";
 */

+(BOOL)getQiHuoStock:(NSString *)num withType:(HansStockKType)type completion:(HansStock_Completion)completed{
    NSString *u = [[NSString alloc] initWithFormat:@"https://stock2.finance.sina.com.cn/futures/api/jsonp.php/var%%20_%@_%d_%ld=/InnerFuturesNewService.getFewMinLine?symbol=%@&type=%d", num, (int)type, time(0), num, (int)type];
    NSURL *url = [[NSURL alloc] initWithString:u];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.f];
    NSURLSessionTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (nil != error){
            dispatch_async(dispatch_get_main_queue(), ^{
                completed(nil);
            });
            return;
        }
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (nil == html){
            dispatch_async(dispatch_get_main_queue(), ^{
                completed(nil);
            });
            return;
        }
        NSArray *kArray = [HansKObject kObjectsFromWebAPI:html];
        [HansStockObject addAverageValues:kArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(kArray);
        });
        return;
    }];
    [task resume];
    return YES;
}
@end
