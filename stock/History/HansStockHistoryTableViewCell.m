//
//  HansStockHistoryTableViewCell.m
//  Stock
//
//  Created by jia yu on 2023/10/22.
//

#import "HansStockHistoryTableViewCell.h"

@interface HansStockHistoryTableViewCell(){
    UILabel *nameLabel;
    UILabel *typeLabel;
}
@end

@implementation HansStockHistoryTableViewCell
@synthesize item;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 3.f, 200.f, 20.f)];
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.f];
        [self addSubview:nameLabel];
        
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 24.f, 200.f, 14.f)];
        typeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10.f];
        [self addSubview:typeLabel];
    }
    return self;
}
-(void)setItem:(HansStockSuggestItem *)_item{
    item = _item;
    nameLabel.text = [item.name stringByAppendingFormat:@"(%@)", item.code];
    typeLabel.text = [HansStockSuggestItem nameForType:item.type];
    
    return;
}
@end
