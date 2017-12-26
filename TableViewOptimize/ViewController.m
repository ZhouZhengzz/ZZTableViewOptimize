//
//  ViewController.m
//  TableViewOptimize
//
//  Created by zhouzheng on 2017/12/5.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "ImageModel.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

static NSString *CELL_ID = @"cellid";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, CellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    TableViewCell *_cell;
}
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [[NSMutableArray alloc] init];
    [self fakeData];
    [self createUI];
}

#pragma mark - >>>>>>>>> 假数据 <<<<<<<<<
- (void)fakeData {
    for (int i=0; i<200; i++) {
        ImageModel *model = [[ImageModel alloc] init];
        model.imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1512466023673&di=78022fca915ecae4f67fb1820e7bc431&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fa1%2F46%2Fd%2F198.jpg";
        model.index = i;
        model.isLoad = NO;
        if (i < 10) {
            model.isLoad = YES;
        }
        [_dataArray addObject:model];
    }
    [_tableView reloadData];
}

#pragma mark - >>>>>>>>> UI <<<<<<<<<
- (void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 150;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[TableViewCell class] forCellReuseIdentifier:CELL_ID];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    //键盘高度
    CGFloat keyboardHeight = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //弹出时间
    CGFloat duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //
    CGFloat bottomHeight = SCREEN_HEIGHT - (_cell.frame.origin.y - _tableView.contentOffset.y) - _cell.frame.size.height;
    
    if (keyboardHeight > bottomHeight) {
        CGFloat changeHeight = keyboardHeight - bottomHeight;
        CGFloat offsetY = _tableView.contentOffset.y;
        [UIView animateWithDuration:duration animations:^{
            _tableView.contentOffset = CGPointMake(0, offsetY+changeHeight);
        }];
    }
}

- (void)textFieldDidBeginEditing:(TableViewCell *)cell {
    _cell = cell;
}

#pragma mark - >>>>>>>>> 按需只加载屏幕可见的cell <<<<<<<<<
- (void)loadShowCells {
    if (_dataArray.count > 0) {
        NSArray *array = [_tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in array) {
            TableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            ImageModel *model = _dataArray[indexPath.row];
            cell.model = model;
        }
    }
}

#pragma mark - >>>>>>>>> scrollViewDelegate <<<<<<<<<
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //停止滑动时再加载
    [self loadShowCells];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        //不滑动时再加载
        [self loadShowCells];
    }
}

#pragma mark - >>>>>>>>> UITableViewDelegate, UITableViewDataSource <<<<<<<<<
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    ImageModel *model = _dataArray[indexPath.row];
    if (model.isLoad) {
        cell.model = model;
    }else {
        cell.model = nil;
    }
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
