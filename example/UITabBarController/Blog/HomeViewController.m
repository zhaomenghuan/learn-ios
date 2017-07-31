//
//  HomeViewController.m
//  Blog
//
//  Created by zhaomenghuan on 2017/7/27.
//  Copyright © 2017年 zhaomenghuan. All rights reserved.
//

#import "HomeViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    // 创建URL
    NSURL* url = [NSURL URLWithString:@"http://www.baidu.com"];
    // 创建NSURLRequest
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    // 加载网页
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
