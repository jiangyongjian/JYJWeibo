//
//  JYJHomeViewController.m
//  JYJ微博
//
//  Created by JYJ on 15/3/11.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJHomeViewController.h"
#import "JYJOneViewController.h"
#import "JYJButton.h"
#import "JYJDropdownMenu.h"
#import "JYJTitleMenuViewController.h"
#import "JYJAccountTool.h"
#import "JYJAccount.h"
#import "UIImageView+WebCache.h"
#import "JYJStatus.h"
#import "JYJStatusFrame.h"
#import "JYJUser.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "JYJStatusTool.h"
#import "JYJUserTool.h"
#import "JYJStatusCell.h"

@interface JYJHomeViewController () <JYJDropdownMenuDelegate>
/**
 *  微博数组(存放着所有的微博数据)
 */
@property (nonatomic, strong) NSMutableArray *statusesFrames;
@property (nonatomic, weak) JYJButton *titleButton;


@end

@implementation JYJHomeViewController

- (NSMutableArray *)statusesFrames
{
    if (!_statusesFrames) {
        _statusesFrames = [NSMutableArray array];
    }
    return _statusesFrames;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = JYJColor(211, 211, 211);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置导航栏的内容
    [self setupNavBar];
    
    // 集成刷新控件
    [self setupRefresh];
    
    // 获取用户信息
    [self setupUserInfo];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkDidSelected:) name:JYJLinkDidSelectedNotification object:nil];
}
- (void)linkDidSelected:(NSNotification *)note
{
    NSString *linkText = note.userInfo[JYJLinkText];
    if ([linkText hasPrefix:@"http"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkText]];
    } else {
        // 跳转控制器
        JYJLog(@"选中了非HTTP链接---%@", note.userInfo[JYJLinkText]);
    }
}

/**
 *  获取用户信息
 */ 
- (void)setupUserInfo
{
    JYJUserInfoParam *param = [JYJUserInfoParam param];
    param.uid = [JYJAccountTool account].uid;
    
    [JYJUserTool userInfoWithParam:param success:^(JYJUserInfoResult *user) {

        // 设置用户的昵称
        [self.titleButton setTitle:user.name forState:UIControlStateNormal];

        // 存储账号信息
        JYJAccount *account = [JYJAccountTool account];
        account.name = user.name;
        [JYJAccountTool save:account];

    } failure:^(NSError *error) {
        JYJLog(@"请求失败-------%@", error);
    }];
    
}

/**
 *   集成刷新控件
 */
- (void)setupRefresh
{

    // 1.下拉刷新
    __weak typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf refreshControlStateChange];
    }];
   
    // 马上进入刷新状态
//    [self.tableView.legendHeader beginRefreshing];
    [self.tableView.header beginRefreshing];
    
    // 2.上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreStatuses];
    }];
     self.tableView.footer.hidden = YES;
   
}

#pragma mark - 刷新
- (void)refresh:(BOOL)fromSelf
{
    if (self.tabBarItem.badgeValue) { //有数字
        //刷新
        __weak typeof(self) weakSelf = self;
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        [self.tableView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf refreshControlStateChange];
        }];

        [self.tableView.header beginRefreshing];
        
    } else if (fromSelf){  // 没有数字
        // 让表格回到最顶部
        NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:firstRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

/**
 *  加载更多的微博数据
 */
- (void)loadMoreStatuses
{
    // 1.封装参数
    JYJHomeStatusesParam *param = [JYJHomeStatusesParam param];
    JYJStatusFrame *lastFrame = [self.statusesFrames lastObject];
    JYJStatus *lastStatus = lastFrame.status;
    if (lastStatus) {
        // max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        param.max_id = @([lastStatus.idstr longLongValue] - 1);
    }
    [JYJStatusTool homeStatusesWithParam:param success:^(JYJHomeStatusesResult *result) {
            // 微博字典数组 --》 微博模型数组
            NSArray *newFrames = [self statusFramesWithStatuses:result.statuses];
            // 将新数据插入到旧数据的最后面
            [self.statusesFrames addObjectsFromArray:newFrames];

            // 重新刷新表格
            [self.tableView reloadData];

            // 拿到当前的上拉刷新控件，结束刷新状态
            [self.tableView.footer endRefreshing];
            
            JYJLog(@"新数据的长度-----%d",newFrames.count);
    } failure:^(NSError *error) {
        JYJLog(@"请求失败--%@", error);
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.footer endRefreshing];
    }];

}
#pragma mark - 加载微博数剧
/**
 *    *  @param statuses 微博模型数组
 */
- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (JYJStatus *status in statuses) {
        JYJStatusFrame *frame = [[JYJStatusFrame alloc] init];
        // 传递微博模型数据，计算所有子控件的frame
        frame.status = status;
        [frames addObject:frame];
    }
    return frames;
}
//- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses
//{
//    NSMutableArray *frames = [NSMutableArray array];
//    for (JYJStatus *status in statuses) {
//        JYJStatusFrame *frame = [[JYJStatusFrame alloc] init];
//        // 传递微博模型数据，计算所有子控件的frame
//        frame.status = status;
//        [frames addObject:frame];
//    }
//    return frames;
//}

/**
 *  当下拉刷新控件进入刷新状态（转圈圈）的时候会自动调用
 */
- (void)refreshControlStateChange
{
    // 1.封装参数
    JYJHomeStatusesParam *param = [JYJHomeStatusesParam param];
    JYJStatusFrame *firstStatusFrame = [self.statusesFrames firstObject];
    JYJStatus *firstStatus = firstStatusFrame.status;
    if (firstStatus) {
        // since_id 	false 	int64 	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
        param.since_id = @([firstStatus.idstr longLongValue]);
    }
    
    // 2.加载微博数据
    [JYJStatusTool homeStatusesWithParam:param success:^(JYJHomeStatusesResult *result) {
        // 获得最新的微博数组
        NSArray *newFrames = [self statusFramesWithStatuses:result.statuses];
        // 将新数据插入到旧数据的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusesFrames insertObjects:newFrames atIndexes:indexSet];

        // 重新刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.header endRefreshing];
        // 添加提示用户最新的微博数量
        [self showNewStatusesCount:newFrames.count];
         self.tableView.footer.hidden = NO;
        JYJLog(@"新数据的长度-----%d", newFrames.count);
    } failure:^(NSError *error) {
        JYJLog(@"请求失败--%@", error);
        // 让刷新控件停止刷新（回复默认状态）
        [self.tableView.header endRefreshing];
    }];
}
/**
 *  提示用户最新的微博数量
 *  @param count 最新的微博数量
 */
- (void)showNewStatusesCount:(int)count
{
    // 0.清零提醒数字
    [UIApplication sharedApplication].applicationIconBadgeNumber -= self.tabBarItem.badgeValue.intValue;
    self.tabBarItem.badgeValue = nil;
    
    
   // 1.创建一个UILable
    UILabel *lable = [[UILabel alloc] init];
    
    // 2.显示文字
    if (count) {
        lable.text = [NSString stringWithFormat:@"共有%d条新的微博数据", count];
    }else{
        lable.text = @"没有最新的微博数据";
    }
    
    // 3.设置背景图片
    [lable setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithName:@"timeline_new_status_background"]]];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    
    // 4.设置frame
    lable.x = 0;
    lable.y = 35;
    lable.width = self.view.width;
    lable.height = 64 - lable.y;
    
    // 添加到导航控制器的View
//    [self.navigationController.view addSubview:lable];
    [self.navigationController.view insertSubview:lable belowSubview:self.navigationController.navigationBar];
    
    // 6.动画
    CGFloat duration = 0.75;
    lable.alpha = 0;
    [UIView animateWithDuration:duration animations:^{
        lable.transform = CGAffineTransformMakeTranslation(0, lable.height);
        lable.alpha = 1;
    } completion:^(BOOL finished) {
        CGFloat delay = 1.0;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            // 恢复到原来的位置
            lable.transform = CGAffineTransformIdentity;
            lable.alpha = 0;
        } completion:^(BOOL finished) {
            // 删除控件
            [lable removeFromSuperview];
        }];
    }];
    
}

/**
 UIViewAnimationOptionCurveEaseInOut            = 0 << 16, // 开始：由慢到快，结束：由快到慢
 UIViewAnimationOptionCurveEaseIn               = 1 << 16, // 由慢到块
 UIViewAnimationOptionCurveEaseOut              = 2 << 16, // 由快到慢
 UIViewAnimationOptionCurveLinear               = 3 << 16, // 线性，匀速
 */

/**
 *  设置导航栏的内容
 */

- (void)setupNavBar
{

    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_friendsearch" highImageName:@"navigationbar_friendsearch_highlighted" target:self action:@selector(friendSearch:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_pop" highImageName:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    // 设置导航栏中间的标题按钮
    JYJButton *titleButton = [[JYJButton alloc] init];
    // 设置尺寸
    
    titleButton.height = 35;
    self.titleButton = titleButton;
    
    //设置文字
    NSString *name = [JYJAccountTool account].name;
    [titleButton setTitle:name ? name : @"首页" forState:UIControlStateNormal];
    
    //设置图标
    [titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    // 设置背景图片
    [titleButton setBackgroundImage:[UIImage resizedImage:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
    [titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    
    // 监听按钮点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
}

- (void)titleClick:(UIButton *)titleButton
{

    // 创建下拉菜单
    JYJDropdownMenu *menu = [JYJDropdownMenu menu];
    menu.delegate = self;
    // 设置内容
    JYJTitleMenuViewController *vc = [[JYJTitleMenuViewController alloc] init];
    vc.view.height = 150;
    vc.view.width = 190;
    menu.contentController = vc;
//    menu.arrowPosition = JYJDropdownMenuArrowPositionRight;
    
    // 显示
    [menu showFrom:titleButton];
    
}

- (void)friendSearch:(UIBarButtonItem *)barButtonItem
{
    barButtonItem.enabled = NO;
    JYJOneViewController *oneVc = [[JYJOneViewController alloc] init];
    [self.navigationController pushViewController:oneVc animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        barButtonItem.enabled = YES;
    });
}


- (void)pop
{
    JYJLog(@"---2");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JYJDropdownMenuDelegate
- (void)dropdownMenuDidDismiss:(JYJDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
//    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];

}
- (void)dropdownMenuDidShow:(JYJDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
//    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.statusesFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JYJStatusCell *cell = [JYJStatusCell cellWithTableView:tableView];
    
    cell.statusFrame = self.statusesFrames[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYJStatusFrame *frame = self.statusesFrames[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewController *newVc = [[UITableViewController alloc] init];
    newVc.view.backgroundColor = [UIColor blueColor];
    newVc.title = @"老子的控制器";
    [self.navigationController pushViewController:newVc animated:YES];
}

@end
