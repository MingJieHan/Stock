//
//  HansStockLogViewController.m
//  stock
//
//  Created by jia yu on 2023/10/16.
//

#import "HansStockLogViewController.h"
#import "HansKObject.h"
#import "HansStockLogTableViewCell.h"

@interface HansStockLogViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *actionItems;
    UITextView *tView;
    UITableView *logTableView;
}

@end

@implementation HansStockLogViewController
@synthesize log;
@synthesize items;

-(id)init{
    self = [super init];
    if (self){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.backgroundColor = [UIColor whiteColor];
        tView = [[UITextView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        tView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tView.editable = NO;
        tView.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.f];
        [self.view addSubview:tView];
        
        logTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        logTableView.delegate = self;
        logTableView.dataSource = self;
        [self.view addSubview:logTableView];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Logs";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(closeLogView)];
}


-(void)setLog:(NSString *)_log{
    log = _log;
    tView.text = log;
    return;
}

-(void)setItems:(NSArray<HansKObject *> *)_items{
    items = _items;
    if (nil == actionItems){
        actionItems = [[NSMutableArray alloc] init];
    }else{
        [actionItems removeAllObjects];
    }

    for (HansKObject *o in items){
        if (o == items.firstObject){
            [actionItems addObject:o];
            continue;
        }
        if (o.type != KObjectActionType_Normal){
            [actionItems addObject:o];
        }
        if (o == items.lastObject){
            [actionItems addObject:o];
        }
    }
    return;
}

-(void)closeLogView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return actionItems.count;
}

-(HansStockLogTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"HansStockLogTableViewCell";
    HansStockLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell){
        cell = [[HansStockLogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.item = [actionItems objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.f;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"This is a demo for stock sale & buy.\n\n\n";
}
@end
