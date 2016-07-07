//
//  JYJTwoViewController.m
//  JYJ微博
//
//  Created by JYJ on 15/3/12.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJTwoViewController.h"
#import "JYJThreeViewController.h"

@interface JYJTwoViewController ()
- (IBAction)jump;

@end

@implementation JYJTwoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"哈哈" style:UIBarButtonItemStyleBordered target:nil action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)jump {
    JYJThreeViewController *threeVc = [[JYJThreeViewController alloc] init];
    threeVc.title = @"第san个控制器";
    [self.navigationController pushViewController:threeVc animated:YES];
}
@end
