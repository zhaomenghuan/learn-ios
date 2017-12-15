#import "ViewController.h"
#import "FloatingButtonWindowManage.h"

@interface ViewController ()

@property(nonatomic,strong)FloatingButtonWindowManage *folatManage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化不可以放到这里，因为放到这里 [UIApplication sharedApplication].keyWindow 还是nil
    
}

- (IBAction)onclickShow:(id)sender {
    self.folatManage=[FloatingButtonWindowManage defaultManagerWithImageName:@"ic_floatingbutton.png"];
    // 浮标的监听
    [self.folatManage setOnClickListener:^{
        // 日志
        NSLog(@"日志");
    } refresh:^{
        NSLog(@"刷新");
    } logout:^{
        NSLog(@"退出");
    }];

    // 显示浮标
    [self.folatManage showWindow];
    
}

- (IBAction)onclickHint:(id)sender {
    //隐藏浮标
    [self.folatManage dissmissWindow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
