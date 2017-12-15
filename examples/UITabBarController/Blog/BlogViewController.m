//
//  BlogViewController.m
//  Blog
//
//  Created by zhaomenghuan on 2017/7/27.
//  Copyright © 2017年 zhaomenghuan. All rights reserved.
//

#import "BlogViewController.h"
#import "BlogDetailViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface BlogViewController ()

@end

@implementation BlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *helloBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, SCREEN_WIDTH - 200, 50)];
    helloBtn.backgroundColor = [UIColor redColor];
    [helloBtn setTitle:@"hello world" forState:UIControlStateNormal];
    [helloBtn addTarget:self action:@selector(showToast) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helloBtn];
}


- (void)showToast{
    NSLog(@"click btn");
    
    BlogDetailViewController *blogDetail = [[BlogDetailViewController alloc] init];
    blogDetail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:blogDetail animated:YES];
    
    NSLog(@"%@", self.navigationController);
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
