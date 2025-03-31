//
//  HansStockSearchResultTableViewCell.m
//  stack
//
//  Created by jia yu on 2023/10/15.
//

#import "HansStockSearchResultTableViewCell.h"

@interface HansStockSearchResultTableViewCell(){
    UILabel *nameLabel;
    UILabel *codeLabel;
    UILabel *kValueLabel;
}
@end

@implementation HansStockSearchResultTableViewCell
@synthesize item;

-(void)setItem:(HansStockSuggestItem *)_item{
    item = _item;
    self.textLabel.text = item.name;
    self.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ %@", 
                                 item.search_code,
                                 [HansStockSuggestItem nameForType:item.type]];
    return;
}
@end
