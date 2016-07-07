//
//  JYJNavigationController.m
//  JYJ微博
//
//  Created by JYJ on 15/3/11.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJNavigationController.h"

@interface JYJNavigationController ()

@end

@implementation JYJNavigationController

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
    // Do any additional setup after loading the view.
}

/**
 *  第一次使用这个类的时候调用一次
 */
+ (void)initialize
{
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];
    
    // 设置UIUINavigationBar的主题
    [self setupNavigationBarTheme];
}

/**
 *  设置NavigationBar的主题
 */
+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    // 设置导航栏的背景
    if (!iOS7) {
        [appearance setBackgroundImage:[UIImage imageWithName:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
       
    }
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor blackColor];
    textAttrs[UITextAttributeFont] = [UIFont boldSystemFontOfSize:20];
    
    // UIOffsetZero是结构体，需要包装成NSValue对象，才能放进字典、数组中
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero ];
    
    [appearance setTitleTextAttributes:textAttrs];
}
/**
 *  设置UIBarButtonItem的主题
 */
+ (void)setupBarButtonItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarbuttonItem的样式
    UIBarButtonItem *apperance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    NSMutableDictionary *textattr = [NSMutableDictionary dictionary];
    textattr[UITextAttributeTextColor] = [UIColor orangeColor];
    textattr[UITextAttributeFont] = [UIFont systemFontOfSize:16];
    [apperance setTitleTextAttributes:textattr forState:UIControlStateNormal];
    
    NSMutableDictionary *highattr = [NSMutableDictionary dictionary];
    highattr[UITextAttributeTextColor] = [UIColor orangeColor];
    highattr[UITextAttributeFont] = [UIFont systemFontOfSize:16];
    [apperance setTitleTextAttributes:highattr forState:UIControlStateNormal];
    
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[UITextAttributeTextColor] = [UIColor lightGrayColor];
    disableTextAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:16];
    [apperance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    /**
     *  设置背景
     */
    // 技巧为了让某个按钮的背景消失，可以设置一张完全透明的背景图片
    [apperance setBackButtonBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        
        //设置导航栏的按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_back" highImageName:@"navigationbar_back_highlighted" target:self action:@selector(back)];
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_more"  highImageName:@"navigationbar_more_highlighted" target:self action:@selector(more)];
        
    }
    [super pushViewController:viewController animated:YES];
}

- (void)back
{
#warning 这里用的是self，因为self就是当前正在使用的导航控制器
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
