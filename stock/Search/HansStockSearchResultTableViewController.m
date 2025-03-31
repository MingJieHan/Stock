//
//  HansStockSearchResultTableViewController.m
//  stack
//
//  Created by jia yu on 2023/10/15.
//

#import "HansStockSearchResultTableViewController.h"
#import "HansStockSearchResultTableViewCell.h"
#import "HansStockViewController.h"
@interface HansStockSearchResultTableViewController ()

@end

@implementation HansStockSearchResultTableViewController
@synthesize results;

-(void)setResults:(NSArray<HansStockSuggestItem *> *)_results{
    results = _results;
    [self.tableView reloadData];
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)openItem:(HansStockSuggestItem *)targetItem{
    HansStockViewController *v = [[HansStockViewController alloc] init];
    v.item = targetItem;
    [self.navigationController pushViewController:v animated:YES];
    return;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return results.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (HansStockSearchResultTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"HansStockSearchResultTableViewCell";
    HansStockSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell){
        cell = [[HansStockSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.item = [results objectAtIndex:indexPath.section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self openItem:[results objectAtIndex:indexPath.section]];
    return;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.f;
}
@end
