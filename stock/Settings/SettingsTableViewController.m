//
//  SettingsTableViewController.m
//  stock
//
//  Created by jia yu on 2023/10/16.
//

#import "SettingsTableViewController.h"

#define StartCashKey @"StartCashKey"
#define RateSecuritiesManagementFeeKey @"RateSecuritiesManagementFeeKey"
#define RateStampDutyKey @"RateStampDutyKey"
#define RateCommissionKey @"RateCommissionKey"
#define MinimumCommissionKey @"MinimumCommissionKey"

SettingsTableViewController *staticSettingsTableViewController;

@interface SettingsTableViewController (){
    float startCash;
    float rateSecuritiesManagementFee;
    float rateStampDuty;
    float rateCommission;
    float minimumCommission;
}
@end

@implementation SettingsTableViewController
+(SettingsTableViewController *)shared{
    if (nil == staticSettingsTableViewController){
        staticSettingsTableViewController = [[SettingsTableViewController alloc] init];
    }
    return staticSettingsTableViewController;
}

-(id)init{
    self = [super init];
    if (self){
        startCash = 1000000.f;
        rateSecuritiesManagementFee = 0.0000687;
        rateStampDuty = 0.001f;
        rateCommission = 0.0003f;
        minimumCommission = 5.f;
        if (nil == [NSUserDefaults.standardUserDefaults valueForKey:StartCashKey]){
            [NSUserDefaults.standardUserDefaults setValue:[NSNumber numberWithFloat:startCash] forKey:StartCashKey];
            [NSUserDefaults.standardUserDefaults setValue:[NSNumber numberWithFloat:rateSecuritiesManagementFee] forKey:RateSecuritiesManagementFeeKey];
            [NSUserDefaults.standardUserDefaults setValue:[NSNumber numberWithFloat:rateStampDuty] forKey:RateStampDutyKey];
            [NSUserDefaults.standardUserDefaults setValue:[NSNumber numberWithFloat:rateCommission] forKey:RateCommissionKey];
            [NSUserDefaults.standardUserDefaults setValue:[NSNumber numberWithFloat:minimumCommission] forKey:MinimumCommissionKey];
            [NSUserDefaults.standardUserDefaults synchronize];
        }else{
            startCash = [[NSUserDefaults.standardUserDefaults valueForKey:StartCashKey] floatValue];
            rateSecuritiesManagementFee = [[NSUserDefaults.standardUserDefaults valueForKey:RateSecuritiesManagementFeeKey] floatValue];
            rateStampDuty = [[NSUserDefaults.standardUserDefaults valueForKey:RateStampDutyKey] floatValue];
            rateCommission = [[NSUserDefaults.standardUserDefaults valueForKey:RateCommissionKey] floatValue];
            minimumCommission = [[NSUserDefaults.standardUserDefaults valueForKey:MinimumCommissionKey] floatValue];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Stock Settings";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(float)testCashValue{
    return startCash;
}

-(float)securitiesManagementFees:(float)value{
    return value * rateSecuritiesManagementFee;
}

-(float)stampDuty:(float)gottedCash{
    return gottedCash * rateStampDuty;
}

-(float)commissionFees:(float)value{
    float res = value * rateCommission;
    if (res < minimumCommission){
        res = minimumCommission;
    }
    return res;
}

-(float)allFeesFor:(float)value isSaled:(BOOL)sale{
    float fee = 0.f;
    fee += [self commissionFees:value];
    fee += [self securitiesManagementFees:value];
    if (sale){
        fee += [self stampDuty:value];
    }
    return fee;
}

-(NSString *)cellIdentifierWith:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return StartCashKey;
        case 1:
            return RateSecuritiesManagementFeeKey;
        case 2:
            return RateStampDutyKey;
        case 3:
            return RateCommissionKey;
        case 4:
            return MinimumCommissionKey;
        default:
            break;
    }
    return @"";
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self cellIdentifierWith:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if ([identifier isEqualToString:StartCashKey]){
        cell.textLabel.text = @"启动金额";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$:%.2f", startCash];
    }else if ([identifier isEqualToString:RateSecuritiesManagementFeeKey]){
        cell.textLabel.text = @"证管费(双向)";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.6f%%", 100.f * rateSecuritiesManagementFee];
    }else if ([identifier isEqualToString:RateStampDutyKey]){
        cell.textLabel.text = @"印花税(卖时)";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f%%", 100.f * rateStampDuty];
    }else if ([identifier isEqualToString:RateCommissionKey]){
        cell.textLabel.text = @"卷商佣金(双向)";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.3f%%", 100.f * rateCommission];
    }else if ([identifier isEqualToString:MinimumCommissionKey]){
        cell.textLabel.text = @"交易单笔最低佣金";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$:%.2f", minimumCommission];
    }
    return cell;
}


@end
