//
//  HansStockViewController.m
//  stack
//
//  Created by jia yu on 2023/10/15.
//

#import "HansStockViewController.h"
#import "HansStockObject.h"
#import "HansKView.h"
#import "HansKObject.h"
#import "HansStockLogViewController.h"
#import "SettingsTableViewController.h"
#import "HansStockHistory.h"

@interface HansStockViewController (){
    UIScrollView *kScrollView;
    HansKView *kView;
    NSArray <HansKObject *> *allItems;
    UISegmentedControl *seg;
    HansStockKType minuteType;
    UIDatePicker *fromDatePicker;
    UIDatePicker *toDatePicker;
    UIButton *magicButton;
    UIButton *logsButton;
    UIButton *favoriteButton;
}

@end

@implementation HansStockViewController
@synthesize item;

-(void)segChanged{
    minuteType = (HansStockKType)[[seg titleForSegmentAtIndex:seg.selectedSegmentIndex] integerValue];
    [self reload];
}

-(id)init{
    self = [super init];
    if (self){
        self.view.backgroundColor = [UIColor whiteColor];
        seg = [[UISegmentedControl alloc] initWithFrame:CGRectMake(60.f, 100.f, self.view.frame.size.width-120.f, 40.f)];
        seg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [seg insertSegmentWithTitle:@"5m" atIndex:0 animated:NO];
        [seg insertSegmentWithTitle:@"15m" atIndex:1 animated:NO];
        [seg insertSegmentWithTitle:@"30m" atIndex:2 animated:NO];
        [seg insertSegmentWithTitle:@"60m" atIndex:3 animated:NO];
        [seg addTarget:self action:@selector(segChanged) forControlEvents:UIControlEventValueChanged];
        minuteType = HansStockKType_5;
        [seg setSelectedSegmentIndex:0];
        [self.view addSubview:seg];
        
        kScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5.f, 130.f, self.view.frame.size.width-10.f, 300.f)];
        kScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:kScrollView];

        kView = [[HansKView alloc] initWithFrame:CGRectMake(0.f, 100.f, self.view.frame.size.width, 300.f)];
        kView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [kScrollView addSubview:kView];
        
        magicButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100.f)/2.f, CGRectGetMaxY(kScrollView.frame) + 50.f, 100.f, 60.f)];
        magicButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [magicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        magicButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        magicButton.layer.borderWidth = 1.f;
        magicButton.layer.cornerRadius = 4.f;
        magicButton.layer.masksToBounds = YES;
        [magicButton setTitle:@"Magic" forState:UIControlStateNormal];
        [magicButton addTarget:self action:@selector(average5WithAverage30) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:magicButton];
        
        logsButton = [[UIButton alloc] initWithFrame:CGRectMake(10.f, CGRectGetMaxY(magicButton.frame)+20.f, 100.f, 40.f)];
        logsButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [logsButton addTarget:self action:@selector(showLogs:) forControlEvents:UIControlEventTouchUpInside];
        [logsButton setTitle:@"Logs" forState:UIControlStateNormal];
        [logsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [logsButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.view addSubview:logsButton];

        favoriteButton = [[UIButton alloc] initWithFrame:CGRectMake(140.f, CGRectGetMaxY(magicButton.frame)+20.f, 100.f, 40.f)];
        favoriteButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [favoriteButton addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
        [favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
        [favoriteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [favoriteButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.view addSubview:favoriteButton];
        
        fromDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10.f, CGRectGetMaxY(kScrollView.frame)+10.f, 60.f, 40.f)];
        fromDatePicker.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        fromDatePicker.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        fromDatePicker.datePickerMode = UIDatePickerModeDate;
//        fromDatePicker.backgroundColor = [UIColor redColor];
//        [fromDatePicker setHoverStyle:UIHoverStyle];
        [fromDatePicker addTarget:self action:@selector(dateScopeChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [self.view addSubview:fromDatePicker];
        
        toDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70.f, CGRectGetMaxY(kScrollView.frame)+10.f, 60.f, 40.f)];
        toDatePicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        toDatePicker.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        toDatePicker.datePickerMode = UIDatePickerModeDate;
//        toDatePicker.backgroundColor = [UIColor blueColor];
//        toDatePicker.datePickerStyle = UIDatePickerStyleWheels;
        [toDatePicker addTarget:self action:@selector(dateScopeChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [self.view addSubview:toDatePicker];
    }
    return self;
}

-(void)dateScopeChanged:(id)sender{
    if (sender == toDatePicker){
        NSMutableArray *keepArray = [[NSMutableArray alloc] init];
        for (HansKObject *o in allItems){
            if (NSOrderedAscending == [o.date compare:toDatePicker.date]){
                [keepArray addObject:o];
            }
        }
        [self keepAction:keepArray];
        return;
    }
    if (sender == fromDatePicker){
        NSMutableArray *keepArray = [[NSMutableArray alloc] init];
        for (HansKObject *o in allItems){
            if (NSOrderedDescending == [o.date compare:fromDatePicker.date]){
                [keepArray addObject:o];
            }
        }
        [self keepAction:keepArray];
        return;
    }
    return;
}

-(void)reload{
    if (item.from == StockFrom_ZH){
        //sz000538
        //sh601857 中国石油
        //sh601988 中国银行
        //sh601606
//        item.type
        [HansStockObject getZhStock:item.search_code withType:minuteType withLen:1024 completion:^(NSArray <HansKObject *>* _Nullable kArray) {
            if (kArray && kArray.count > 0){
                [self keepAction:kArray];
            }
            return;
        }];
        return;
    }else if (item.from == StockFrom_US){
        [HansStockObject getUsStock:item.search_code withType:minuteType withLen:1024 completion:^(NSArray<HansKObject *> * _Nullable kArray) {
            if (kArray && kArray.count > 0){
                [self keepAction:kArray];
            }
        }];
        return;
    }else if (item.from == StockFrom_QIHUO){
        [HansStockObject getQiHuoStock:item.search_code withType:minuteType completion:^(NSArray<HansKObject *> * _Nullable kArray) {
            if (kArray && kArray.count > 0){
                [self keepAction:kArray];
            }
        }];
        return;
    }
    NSLog(@"TODO for Other sources");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Contact developer" message:@"There is a uncomplet function, please let developer see that. thanks!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}

-(void)setItem:(HansStockSuggestItem *)_item{
    item = _item;
    logsButton.enabled = NO;
    self.title = item.name;
    minuteType = item.type;
    if (0 == (int)minuteType){
        minuteType = HansStockKType_5;
    }
    switch (minuteType) {
        case HansStockKType_5:
            [seg setSelectedSegmentIndex:0];
            break;
        case HansStockKType_15:
            [seg setSelectedSegmentIndex:1];
            break;
        case HansStockKType_30:
            [seg setSelectedSegmentIndex:2];
            break;
        case HansStockKType_60:
            [seg setSelectedSegmentIndex:3];
            break;
        default:
            break;
    }
    [self reload];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [kScrollView setContentOffset:CGPointZero animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [kScrollView setContentOffset:CGPointMake(kView.frame.size.width - kScrollView.frame.size.width, 0.f) animated:YES];
    [fromDatePicker setFrame:CGRectMake(10.f, CGRectGetMaxY(kScrollView.frame)+5.f, 100.f, 40.f)];
    [toDatePicker setFrame:CGRectMake(self.view.frame.size.width - 110.f, CGRectGetMaxY(kScrollView.frame)+5.f, 100.f, 40.f)];
}

-(void)keepAction:(NSArray <HansKObject *>*)results{
    allItems = [[NSMutableArray alloc] initWithArray:results];
    float itemWidth = 21.35f;
    if ([UIDevice.currentDevice.model isEqualToString:@"iPad"]){
        //iPad only
        itemWidth = 12.f;
    }
    [kView setFrame:CGRectMake(0.f, 0.f, kScrollView.frame.size.width * itemWidth, kView.frame.size.height)];
    kView.kItems = allItems;
    [kScrollView setContentSize:kView.frame.size];
    
    fromDatePicker.minimumDate = allItems.firstObject.date;
    fromDatePicker.date = allItems.firstObject.date;
    fromDatePicker.maximumDate = allItems.lastObject.date;
    toDatePicker.minimumDate = allItems.firstObject.date;
    toDatePicker.date = allItems.lastObject.date;
    toDatePicker.maximumDate = allItems.lastObject.date;
    
    [kScrollView setContentOffset:CGPointZero animated:NO];
    [UIView animateWithDuration:1.f animations:^{
        [self->kScrollView setContentOffset:CGPointMake(self->kView.frame.size.width - self->kScrollView.frame.size.width, 0.f)];
    }];
}

-(NSString *)average5WithAverage30{
    float cash = DefaultCash;
    float stock = DefaultStock;
    NSMutableString *log = [[NSMutableString alloc] init];
    [log appendFormat:@"Stock buy & sale log:\n\n"];
    float lastAverage20 = allItems.firstObject.average20;
    for (HansKObject *o in allItems){
        float price = [o price];
        
        if ((o.average5 - o.average30) > price * 0.001f
            && (o.average5 - o.average10) > price * 0.001f){
            //Buy
            if (cash > 0){
                //Buy action
                o.type = KObjectActionType_Buy;
                stock = cash/[o price];
                float fee = [SettingsTableViewController.shared allFeesFor:cash isSaled:NO];
                cash = 0.f;
                cash -= fee;
                [log appendFormat:@"%@: Buy stock %.2f price:%.2f\n",  o.dayTime, stock, [o price]];
            }
        }else if ((o.average10 - o.average5) > price * 0.001f){
            //Sale
            if (stock > 0){
                //sale action
                o.type = KObjectActionType_Saled;
                float value = stock * price;
                float fee = [SettingsTableViewController.shared allFeesFor:value isSaled:YES];
                cash += value;
                cash -= fee;
                stock = 0.f;
                [log appendFormat:@"%@: Saled cash:%.2f price:%.2f\n", o.dayTime, cash, price];
            }
        }
        
        o.cash = cash;
        o.stock = stock;
        lastAverage20 = o.average20;
    }
    
    //计算后强制卖出所有股票
    if (stock > 0){
        float price = (allItems.lastObject.open + allItems.lastObject.close)/2.f;
        cash += stock * price;
    }
    
    NSMutableString *title = [[NSMutableString alloc] init];
    NSMutableString *message = [[NSMutableString alloc] init];;
    if (cash > DefaultCash){
        [title appendFormat:@"Win %.1f%%", 100.f * (cash - DefaultCash)/DefaultCash];
        [message appendFormat:@"Stock result is %.0f from %.0f.", cash, DefaultCash];
        [log appendString:message];
    }else{
        [title appendFormat:@"Lost %.1f%%", -100.f * (cash-DefaultCash)/DefaultCash];
        [message appendFormat:@"You lost %.0f.", DefaultCash - cash];
        [log appendString:message];
    }
    [message appendString:@"\n卖: 5日均线跌破10日均线."];
    [message appendString:@"\n买: 5日均线超过30日均线."];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OKay" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Logs" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self showLogs:log];
    }]];
    [self presentViewController:alert animated:YES completion:^{
        self->kView.kItems = self->allItems;
    }];
    logsButton.enabled = YES;
    favoriteButton.enabled = YES;
    return log;
}

-(void)showLogs:(NSString * _Nullable )log{
    HansStockLogViewController *v = [[HansStockLogViewController alloc] init];
    if (log && [log isKindOfClass:[NSString class]] &&  log.length > 0){
        v.log = log;
    }else{
        v.log = @"";
    }
    v.items = self->allItems;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:v];
    nav.view.backgroundColor = [UIColor whiteColor];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
    return;
}

-(void)favoriteAction:(id)sender{
    item.type = minuteType;
    [HansStockHistory addFavorite:item];
    return;
}
@end
