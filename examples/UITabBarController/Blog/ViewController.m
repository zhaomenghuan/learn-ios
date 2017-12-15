//
//  ViewController.m
//  Blog
//
//  Created by zhaomenghuan on 2017/7/27.
//  Copyright © 2017年 zhaomenghuan. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "BlogViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建子控制器
    HomeViewController *homeVC=[[HomeViewController alloc] init];
    [self setTabBarItem:homeVC.tabBarItem
                  title:@"首页"
              titleSize:13.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"i_tab_home_selected"
     selectedTitleColor:[UIColor redColor]
            normalImage:@"i_tab_home_normal"
       normalTitleColor:[UIColor grayColor]];
    
    BlogViewController *blogVC=[[BlogViewController alloc] init];
    [self setTabBarItem:blogVC.tabBarItem
                  title:@"博文"
              titleSize:13.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"i_tab_blog_selected"
     selectedTitleColor:[UIColor redColor]
            normalImage:@"i_tab_blog_normal"
       normalTitleColor:[UIColor grayColor]];
    
    UINavigationController *homeNV = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UINavigationController *blogNV = [[UINavigationController alloc] initWithRootViewController:blogVC];
    // 把子控制器添加到UITabBarController
    self.viewControllers = @[homeNV, blogNV];
}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                title:(NSString *)title
            titleSize:(CGFloat)size
        titleFontName:(NSString *)fontName
        selectedImage:(NSString *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
          normalImage:(NSString *)unselectedImage
     normalTitleColor:(UIColor *)unselectColor
{
    
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // S未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateNormal];
    
    // 选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
