//
//  JYJMessageViewController.m
//  JYJ微博
//
//  Created by JYJ on 15/3/11.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJMessageViewController.h"
#import "JYJSearchBar.h"
#import "JYJPerson.h"
#import "JYJPersonTool.h"

@interface JYJMessageViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) NSArray *persons;
@property (nonatomic, weak) UISearchBar *searchBar;

@end

@implementation JYJMessageViewController
- (NSArray *)persons
{
    if (!_persons) {
        self.persons = [JYJPersonTool query];
    }
    return _persons;
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写私信" style:UIBarButtonItemStyleDone target:self action:@selector(composeMsg)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

- (void)composeMsg
{
    JYJLog(@"composeMsg---");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"消息测试数据--%d", indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewController *newVc = [[UITableViewController alloc] init];
    newVc.view.backgroundColor = [UIColor blueColor];
    newVc.title = @"老子的控制器";
    [self.navigationController pushViewController:newVc animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(0, 0, 320, 44);
    searchBar.delegate = self;
    self.searchBar = searchBar;
    return searchBar;
}


#pragma mark - 收缩框代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // 根据查询条件收缩联系人信息
    self.persons = [JYJPersonTool queryWithCondition:searchText];
    // 刷新表格
    [self.tableView reloadData];
    
}

@end
