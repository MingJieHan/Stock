//
//  HansStockLogTableViewCell.m
//  stock
//
//  Created by jia yu on 2023/10/16.
//

#import "HansStockLogTableViewCell.h"
#import "HansKObject.h"
#import "HansStockViewController.h"

@interface HansStockLogTableViewCell(){
    UILabel *valueLabel;
    UILabel *timeLabel;
    UILabel *cashLabel;
    UILabel *stockLabel;
    UILabel *actionLabel;
}
@end

@interface HansStockLogTableViewCell(){
    UIColor *winColor;
    UIColor *lostColor;
}
@end

@implementation HansStockLogTableViewCell
@synthesize item;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.backgroundColor = [UIColor whiteColor];
        lostColor = [UIColor colorWithRed:0.04 green:0.34 blue:0.f alpha:1.f];
        winColor = [UIColor colorWithRed:0.73 green:0.f blue:0.01f alpha:1.f];

        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.f, 14.f, 100.f, 24.f)];
        valueLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.f];
        [self addSubview:valueLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(105.f, 8.f, 200.f, 18.f)];
        timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.f];
        [self addSubview:timeLabel];
        
        actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(260.f, 14.f, 100.f, 24.f)];
        actionLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.f];
        actionLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:actionLabel];
        
        cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.f, 30.f, 100.f, 14.f)];
        cashLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10.f];
        [self addSubview:cashLabel];
        
        stockLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.f, 30.f, 100.f, 14.f)];
        stockLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10.f];
        [self addSubview:stockLabel];
    }
    return self;
}

-(void)setItem:(HansKObject *)_item{
    item = _item;
    float price = (item.open+item.close)/2.f;
    timeLabel.text = item.dayTime;
    cashLabel.text = [NSString stringWithFormat:@"$%.0f", item.cash];
    stockLabel.text = [NSString stringWithFormat:@"%.2f", item.stock];
    if (KObjectActionType_Buy == item.type){
        actionLabel.textColor = winColor;
        actionLabel.text = [NSString stringWithFormat:@"买:%.2f", price];
    }else if (KObjectActionType_Saled == item.type){
        actionLabel.textColor = lostColor;
        actionLabel.text = [NSString stringWithFormat:@"卖:%.2f", price];
    }else{
        actionLabel.text = @"";
    }
    float value = item.cash + item.stock * price;
    float percent = 100.f * value/DefaultCash;
    valueLabel.text = [NSString stringWithFormat:@"%.2f%%", percent];
    if (percent > 100.01f){
        valueLabel.textColor = winColor;
    }else if (percent < 99.99f){
        valueLabel.textColor = lostColor;
    }else{
        valueLabel.textColor = [UIColor grayColor];
    }
    return;
}
@end
