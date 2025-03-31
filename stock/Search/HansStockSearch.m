//
//  HansStockSearch.m
//  stack
//
//  Created by jia yu on 2023/10/15.
//

#import "HansStockSearch.h"


/*
 https://suggest3.sinajs.cn/suggest/type=&key=AAPL&name=suggestdata_1697328347
 var suggestdata_1697328347="AAPL,41,aapl,aapl,苹果,,苹果,99,1,ESG;AAPL,103,aapl,aapl,AAPL,,AAPL,99,1,;YieldMax AAPL Option Income Strategy ETF,41,aply,aply,YieldMax AAPL Option Income Strategy ETF,,YieldMax AAPL Option Income Strategy ETF,99,1,;GraniteShares 1.75x Long AAPL Daily ETF,41,aapb,aapb,GraniteShares 1.75x Long AAPL Daily ETF,,GraniteShares 1.75x Long AAPL Daily ETF,99,1,;Direxion Daily AAPL Bear 1X Shares,41,aapd,aapd,Direxion Daily AAPL Bear 1X Shares,,Direxion Daily AAPL Bear 1X Shares,99,1,;Direxion Daily AAPL Bull 15X Shares,41,aapu,aapu,Direxion Daily AAPL Bull 15X Shares,,Direxion Daily AAPL Bull 15X Shares,99,1,;Leverage Shares -3x Short Apple (AAPL) ETP,103,aaps,aaps,Leverage Shares -3x Short Apple (AAPL) ETP,,Leverage Shares -3x Short Apple (AAPL) ETP,99,1,";
 */
@implementation HansStockSearch
+(BOOL)searchWord:(NSString *)word completion:(HansStockSearch_Completion)completion{
    if (nil == word || word.length < 1){
        return NO;
    }
    NSString *suggestData = [NSString stringWithFormat:@"%ld", time(0)];
    NSString *url = [NSString stringWithFormat:@"https://suggest3.sinajs.cn/suggest/type=&key=%@&name=suggestdata_%@", word, suggestData];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.f];
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (nil != error){
            NSLog(@"HansStockSearch error.");
            return;
        }
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *html = [[NSString alloc] initWithData:data encoding:enc];
        NSRange range = [html rangeOfString:suggestData];
        if (0 == range.location){
            NSLog(@"suggest data failed.");
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
            return;
        }
        NSArray *array = [html componentsSeparatedByString:@"="];
        if (2 != array.count){
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
            return;
        }
        NSString *info = array.lastObject;
        if ([[info substringToIndex:1] isEqualToString:@"\""]){
            info = [info substringFromIndex:1];
        }
        array = [info componentsSeparatedByString:@";"];
        NSMutableArray *results = [[NSMutableArray alloc] init];
        for (NSString *s in array){
            HansStockSuggestItem *item = [[HansStockSuggestItem alloc] initWithString:s];
            if (item){
                [results addObject:item];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(results);
        });
        return;
    }];
    [task resume];
    return YES;
}
@end
