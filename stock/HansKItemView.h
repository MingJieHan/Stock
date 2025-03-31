//
//  HansKView.h
//  stack
//
//  Created by jia yu on 2023/10/13.
//

#import <UIKit/UIKit.h>
#import "HansKObject.h"

NS_ASSUME_NONNULL_BEGIN
@interface HansKItemView : UIView
@property (nonatomic) float maximumVolume;
@property (nonatomic) float minimumVolume;
@property (nonatomic) HansKObject *object;
@end
NS_ASSUME_NONNULL_END
