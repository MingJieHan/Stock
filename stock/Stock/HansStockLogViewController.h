//
//  HansStockLogViewController.h
//  stock
//
//  Created by jia yu on 2023/10/16.
//

#import <UIKit/UIKit.h>
@class HansKObject;

NS_ASSUME_NONNULL_BEGIN
@interface HansStockLogViewController : UIViewController
-(id)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
-(id)initWithNibName:(NSString * _Nullable) nibNameOrNil bundle:(NSBundle * _Nullable )nibBundleOrNil NS_UNAVAILABLE;

@property (nonatomic) NSString *log;
@property (nonatomic) NSArray <HansKObject *>*items;
@end
NS_ASSUME_NONNULL_END
