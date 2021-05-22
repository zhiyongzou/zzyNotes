//
//  ViewController.m
//  CommonTest
//
//  Created by zzyong on 2021/3/17.
//

#import "VCCell.h"
#import "VCModel.h"
#import "ViewController.h"
#import "ViewController+DataSource.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTestList];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        [_tableView registerClass:[VCCell class] forCellReuseIdentifier:@"VCCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.testList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VCModel *testModel = [self.testList objectAtIndex:indexPath.row];
    VCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VCCell" forIndexPath:indexPath];
    cell.model = testModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    VCModel *testModel = [self.testList objectAtIndex:indexPath.row];
    UIViewController *targetVC = testModel.targetVC();
    targetVC.title = testModel.title;
    [self.navigationController pushViewController:targetVC animated:YES];
}

@end
