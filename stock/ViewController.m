//
//  ViewController.m
//  stack
//
//  Created by jia yu on 2023/10/13.
//

#import "ViewController.h"
#import "HansStockSearch.h"
#import "HansStockSearchResultTableViewController.h"
#import "SettingsTableViewController.h"
#import "HansStockHistory.h"
#import "HansStockViewController.h"
#import "HansStockHistoryTableViewCell.h"
#import <HansServer/HansServer.h>

#define LAST_SEARCH_WORD @"LAST_SEARCH_WORD"

@interface ViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    UITextField *searchField;
    UIButton *searchButton;
    NSMutableArray <HansStockSuggestItem *>*historys;
    UITableView *historyTableView;
}

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    float y = 0.f;
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [b setFrame:CGRectMake(20.f, 100.f, 40.f, 40.f)];
    b.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
//    [b setTitle:@"Settings" forState:UIControlStateNormal];
//    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
//    b.backgroundColor = [UIColor grayColor];
//    b.layer.masksToBounds = YES;
//    b.layer.cornerRadius = 6.f;
    [self.view addSubview:b];
    
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(20.f, 140.f, self.view.frame.size.width-40.f, 40.f)];
    searchField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchField.delegate = self;
    searchField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchField.layer.borderWidth = 1.f;
    searchField.layer.cornerRadius = 4.f;
    searchField.layer.masksToBounds = YES;
    searchField.placeholder = @"Name, Code, etc.";
    searchField.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22.f];
    searchField.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:searchField];    
    
    searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 120.f, 40.f)];
    searchButton.backgroundColor = [UIColor blueColor];
    searchButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.f];
    [searchButton setTitle:@" Search " forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [searchButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    searchField.rightViewMode = UITextFieldViewModeAlways;
    searchField.rightView = searchButton;
    
    y = CGRectGetMaxY(searchField.frame)+20.f;
    historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(10.f, y, self.view.frame.size.width-20.f, self.view.frame.size.height-y-30.f) style:UITableViewStylePlain];
    historyTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    [self.view addSubview:historyTableView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
//    [searchField becomeFirstResponder];
    
    NSString *word = [NSUserDefaults.standardUserDefaults valueForKey:LAST_SEARCH_WORD];
    if (word && word.length > 0){
        searchField.text = word;
    }
    historys = [HansStockHistory loadHistorys];
    [historyTableView reloadData];
    return;
}

-(void)searchButtonAction:(id)sender{
    if (searchField.text.length > 0){
        [self searchWord:searchField.text];
    }
    return;
}

-(void)openItem:(HansStockSuggestItem *)item{
    HansStockViewController *v = [[HansStockViewController alloc] init];
    v.item = item;
    [self.navigationController pushViewController:v animated:YES];
    return;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    searchButton.enabled = NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0){
        [self searchWord:textField.text];
        return YES;
    }
    return NO;
}

-(void)textChanged:(NSNotification *)notification{
    if (searchField.text.length > 0){
        searchButton.enabled = YES;
    }else{
        searchButton.enabled = NO;
    }
    return;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return historys.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(HansStockHistoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"HansStockSearchResultTableViewCell";
    HansStockHistoryTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell){
        cell = [[HansStockHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.item = [historys objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self openItem:[historys objectAtIndex:indexPath.row]];
    return;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [HansStockHistory removeFavorite:[historys objectAtIndex:indexPath.row]];
    historys = [HansStockHistory loadHistorys];
    [historyTableView reloadData];
    return;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (searchField.isFirstResponder){
        [searchField resignFirstResponder];
    }
    return;
}

#pragma mark - MyFunction
-(void)searchWord:(NSString *)word{
    [HansStockSearch searchWord:word completion:^(NSArray<HansStockSuggestItem *> * _Nonnull suggestions) {
        if (suggestions && suggestions.count > 0){
            [NSUserDefaults.standardUserDefaults setValue:self->searchField.text forKey:LAST_SEARCH_WORD];
            [NSUserDefaults.standardUserDefaults synchronize];
            
            HansStockSearchResultTableViewController *v = [[HansStockSearchResultTableViewController alloc] initWithStyle:UITableViewStyleInsetGrouped];
            v.results = suggestions;
            v.title = word;
            [self.navigationController pushViewController:v animated:YES];
        }else{
            [UIHans alertTitle:@"Result" withMessage:@"Stock search result is empty."];
        }
        return;
    }];
    return;
}

-(void)settingAction{
    [self.navigationController pushViewController:[SettingsTableViewController shared] animated:YES];
    return;
}

@end
