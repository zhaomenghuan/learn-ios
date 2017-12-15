#import "FloatingButtonWindowManage.h"
#import "UIViewHelper.h"

#define kk_WIDTH self.frame.size.width
#define kk_HEIGHT self.frame.size.height

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define animateDuration 0.3         // 位置改变动画时间
#define showDuration 0.1            // 展开动画时间
#define statusChangeDuration  3.0   // 状态改变时间
#define normalAlpha  1.0            // 正常状态时背景alpha值
#define sleepAlpha  0.5             // 隐藏到边缘时的背景alpha值
#define marginWith  12              // 每个item的间隔
#define marginBorderLeft  60        // 左边的距离
#define folatViewWidth  280         // 浮标的宽度
#define folatViewHeight  55         // 浮标的高度
#define padding 5                   // item 距离顶部的距离

@interface FloatingButtonWindowManage ()

@property(nonatomic,strong)UIPanGestureRecognizer *pan;

@property(nonatomic,strong)UIButton *mainImageButton;     // 浮动按钮
@property(nonatomic,strong)UIView *leftViewContrainer;    // 停靠左边缘的 View 容器
@property(nonatomic,strong)UIView *rightViewContrainer;   // 停靠右边缘的 View 容器
@property(nonatomic,assign)BOOL isOpen;                   // 记录是打开还是关闭

// 退出按钮
@property(nonatomic,weak)UIView *leftLogout;
@property(nonatomic,weak)UIView *rightLogout;
// 刷新按钮
@property(nonatomic,weak)UIView *leftRefresh;
@property(nonatomic,weak)UIView *rightRefresh;
// 控制台按钮
@property(nonatomic,weak)UIView *leftConsole;
@property(nonatomic,weak)UIView *rightConsole;

@end


@implementation FloatingButtonWindowManage

- (instancetype)initWithImageName:(NSString*)name
{
    if(self = [super init])
    {
        // 初始化视图
        [self initView:name];
        // 初始化事件
        [self initEvent];
    }
    return self;
}

/**
 * 初始化视图
 */
-(void)initView:(NSString*)name
{
    /**
     * 添加默认浮动按钮
     */
    self.mainImageButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mainImageButton setFrame:(CGRect){
        kScreenWidth - folatViewHeight,
        kScreenHeight/2,
        folatViewHeight*SCALEY,
        folatViewHeight*SCALEY
    }];
    [self.mainImageButton setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    self.mainImageButton.alpha = 0.0;
    [_mainImageButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    /**
     * 创建停靠左边缘的视图
     */
    self.leftViewContrainer = [[UIView alloc] init];
    self.leftViewContrainer.backgroundColor = [UIColor whiteColor];
    self.leftViewContrainer.layer.cornerRadius = (folatViewHeight/2*SCALEY);
    self.leftViewContrainer.layer.masksToBounds = YES;
    self.leftViewContrainer.layer.borderWidth=1;
    self.leftViewContrainer.layer.borderColor=[[UIViewHelper RGBStringDecode:LINE] CGColor];
    [self.leftViewContrainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewWidth*SCALEX, folatViewHeight*SCALEY));
    }];
    [self.leftViewContrainer setAlpha:0];
    
    // 退出view
    UIView *leftLogoutView = [[UIView alloc] init];
    self.leftLogout = leftLogoutView;
    [self.leftViewContrainer addSubview:leftLogoutView];
    [leftLogoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewHeight*SCALEX, folatViewHeight*SCALEY));
        make.left.mas_equalTo(self.leftViewContrainer.mas_left).offset(marginBorderLeft*SCALEX);
        make.top.mas_equalTo(self.leftViewContrainer.mas_top);
    }];
    // 退出图标
    UIImageView *leftLogoutIcon = [UIViewHelper makeImageView:@"ic_logout.png"
                                                        width:folatViewHeight/2*SCALEY
                                                        height:folatViewHeight/2*SCALEY];
    [leftLogoutView addSubview:leftLogoutIcon];
    [leftLogoutIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(leftLogoutView.mas_centerX);
        make.top.mas_equalTo(leftLogoutView.mas_top).offset(padding*SCALEY);
    }];
    // 退出文字标签
    UILabel *leftLogoutLabel = [[UILabel alloc] init];
    leftLogoutLabel.font = [UIFont systemFontOfSize:12.0*SCALEY];
    leftLogoutLabel.text = @"退出";
    [leftLogoutView addSubview:leftLogoutLabel];
    [leftLogoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16*SCALEY);
        make.centerX.mas_equalTo(leftLogoutView.mas_centerX);
        make.bottom.mas_equalTo(leftLogoutView.mas_bottom).offset(-padding*SCALEY);
    }];
    
    // 竖线
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIViewHelper RGBStringDecode:LINE];
    [self.leftViewContrainer addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1*SCALEX);
        make.top.mas_equalTo(self.leftViewContrainer.mas_top).offset(10*SCALEY);
        make.bottom.mas_equalTo(self.leftViewContrainer.mas_bottom).offset(-(10*SCALEY));
        make.left.mas_equalTo(leftLogoutView.mas_right).offset(marginWith/2*SCALEX);
    }];
    
    // 刷新view
    UIView *leftRefreshView = [[UIView alloc] init];
    self.leftRefresh = leftRefreshView;
    [self.leftViewContrainer addSubview:leftRefreshView];
    [leftRefreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewHeight*SCALEX, folatViewHeight*SCALEY));
        make.left.mas_equalTo(leftLine.mas_right).offset(marginWith/2*SCALEX);
        make.top.mas_equalTo(self.leftViewContrainer.mas_top);
    }];
    // 刷新图标
    UIImageView *leftRefreshIcon = [UIViewHelper makeImageView:@"ic_refresh.png"
                                                         width:folatViewHeight/2*SCALEY
                                                         height:folatViewHeight/2*SCALEY];
    [leftRefreshView addSubview:leftRefreshIcon];
    [leftRefreshIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(leftRefreshView.mas_centerX);
        make.top.mas_equalTo(leftRefreshView.mas_top).offset(padding*SCALEY);
    }];
    
    // 刷新文字标签
    UILabel *leftRefreshLabel = [[UILabel alloc] init];
    leftRefreshLabel.font = [UIFont systemFontOfSize:12.0*SCALEY];
    leftRefreshLabel.text = @"刷新";
    [leftRefreshView addSubview:leftRefreshLabel];
    [leftRefreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16*SCALEY);
        make.centerX.mas_equalTo(leftRefreshView.mas_centerX);
        make.bottom.mas_equalTo(leftRefreshView.mas_bottom).offset(-padding*SCALEY);
    }];
    
    // 竖线
    UIView *leftLine2 = [[UIView alloc] init];
    leftLine2.backgroundColor=[UIViewHelper RGBStringDecode:LINE];
    [self.leftViewContrainer addSubview:leftLine2];
    [leftLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1*SCALEX);
        make.top.mas_equalTo(self.leftViewContrainer.mas_top).offset(10*SCALEY);
        make.bottom.mas_equalTo(self.leftViewContrainer.mas_bottom).offset(-(10*SCALEY));
        make.left.mas_equalTo(leftRefreshView.mas_right).offset(marginWith/2*SCALEX);
    }];
    
    // 控制台按钮的view
    UIView *leftConsoleView = [[UIView alloc] init];
    self.leftConsole = leftConsoleView;
    [self.leftViewContrainer addSubview:leftConsoleView];
    [leftConsoleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewHeight*SCALEX, folatViewHeight*SCALEY));
        make.left.mas_equalTo(leftLine2).offset(marginWith/2 *SCALEX);
        make.top.mas_equalTo(self.leftViewContrainer.mas_top);
    }];
    // 控制台按钮图标
    UIImageView *leftConsoleIcon = [UIViewHelper makeImageView:@"ic_console.png"
                                                         width:folatViewHeight/2*SCALEY
                                                         height:folatViewHeight/2*SCALEY];
    [leftConsoleView addSubview:leftConsoleIcon];
    [leftConsoleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(leftConsoleView.mas_centerX);
        make.top.mas_equalTo(leftConsoleView.mas_top).offset(padding*SCALEY);
    }];
    // 控制台按钮文字标签
    UILabel *leftConsoleLabel = [[UILabel alloc] init];
    leftConsoleLabel.font = [UIFont systemFontOfSize:12.0*SCALEY];
    leftConsoleLabel.text=@"控制台";
    [leftConsoleView addSubview:leftConsoleLabel];
    [leftConsoleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16*SCALEY);
        make.centerX.mas_equalTo(leftConsoleView.mas_centerX);
        make.bottom.mas_equalTo(leftConsoleView.mas_bottom).offset(-padding*SCALEY);
    }];
    
    /**
     * 创建停靠右边缘的视图
     */
    self.rightViewContrainer = [[UIView alloc] init];
    self.rightViewContrainer.backgroundColor = [UIColor whiteColor];
    self.rightViewContrainer.layer.cornerRadius = (folatViewHeight/2*SCALEY);
    self.rightViewContrainer.layer.masksToBounds = YES;
    self.rightViewContrainer.layer.borderWidth = 1;
    self.rightViewContrainer.layer.borderColor = [[UIViewHelper RGBStringDecode:LINE] CGColor];
    [self.rightViewContrainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewWidth*SCALEX, folatViewHeight*SCALEY));
    }];
    [self.rightViewContrainer setAlpha:0];
    
    // 退出view
    UIView *rightLogoutView = [[UIView alloc] init];
    self.rightLogout = rightLogoutView;
    [self.rightViewContrainer addSubview:rightLogoutView];
    [rightLogoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewHeight*SCALEX, folatViewHeight*SCALEY));
        make.right.mas_equalTo(self.rightViewContrainer.mas_right).offset(-marginBorderLeft*SCALEX);
        make.top.mas_equalTo(self.rightViewContrainer.mas_top);
    }];
    // 退出图标
    UIImageView *rightLogoutIcon = [UIViewHelper makeImageView:@"ic_logout.png"
                                                         width:folatViewHeight/2*SCALEY
                                                        height:folatViewHeight/2*SCALEY];
    [rightLogoutView addSubview:rightLogoutIcon];
    [rightLogoutIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(rightLogoutView.mas_centerX);
        make.top.mas_equalTo(rightLogoutView.mas_top).offset(padding*SCALEY);
    }];
    // 退出文字标签
    UILabel *rightLogoutLabel = [[UILabel alloc] init];
    rightLogoutLabel.font = [UIFont systemFontOfSize:12.0*SCALEY];
    rightLogoutLabel.text=@"退出";
    [rightLogoutView addSubview:rightLogoutLabel];
    [rightLogoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(rightLogoutView.mas_bottom).offset(-padding*SCALEY);
        make.height.mas_equalTo(16*SCALEY);
        make.centerX.mas_equalTo(rightLogoutView.mas_centerX);
    }];
    
    // 竖线
    UIView *rightline=[[UIView alloc] init];
    rightline.backgroundColor=[UIViewHelper RGBStringDecode:LINE];
    [self.rightViewContrainer addSubview:rightline];
    [rightline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1*SCALEX);
        make.top.mas_equalTo(self.rightViewContrainer.mas_top).offset(10*SCALEY);
        make.bottom.mas_equalTo(self.rightViewContrainer.mas_bottom).offset(-(10*SCALEY));
        make.right.mas_equalTo(rightLogoutView.mas_left).offset(-marginWith/2 *SCALEX);
    }];
    
    // 刷新view
    UIView *rightRefreshView = [[UIView alloc] init];
    self.rightRefresh = rightRefreshView;
    [self.rightViewContrainer addSubview:rightRefreshView];
    [rightRefreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewHeight*SCALEX, folatViewHeight*SCALEY));
        make.right.mas_equalTo(rightline.mas_left).offset(-marginWith/2 *SCALEX);
        make.top.mas_equalTo(self.rightViewContrainer.mas_top);
    }];
    // 刷新图标
    UIImageView *rightRefreshIcon = [UIViewHelper makeImageView:@"ic_refresh.png"
                                                          width:folatViewHeight/2*SCALEY
                                                         height:folatViewHeight/2*SCALEY];
    [rightRefreshView addSubview:rightRefreshIcon];
    [rightRefreshIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(rightRefreshView.mas_centerX);
        make.top.mas_equalTo(rightRefreshView.mas_top).offset(padding*SCALEY);
    }];
    // 刷新文字标签
    UILabel *rightRefreshLabel = [[UILabel alloc] init];
    rightRefreshLabel.font = [UIFont systemFontOfSize:12.0*SCALEY];
    rightRefreshLabel.text = @"刷新";
    [rightRefreshView addSubview:rightRefreshLabel];
    [rightRefreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(rightRefreshView.mas_centerX);
        make.bottom.mas_equalTo(rightRefreshView.mas_bottom).offset(-padding*SCALEY);
        make.height.mas_equalTo(16*SCALEY);
    }];
    
    // 竖线
    UIView *rightline2=[[UIView alloc] init];
    rightline2.backgroundColor=[UIViewHelper RGBStringDecode:LINE];
    [self.rightViewContrainer addSubview:rightline2];
    [rightline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1*SCALEX);
        make.top.mas_equalTo(self.rightViewContrainer.mas_top).offset(10*SCALEY);
        make.bottom.mas_equalTo(self.rightViewContrainer.mas_bottom).offset(-(10*SCALEY));
        make.right.mas_equalTo(rightRefreshView.mas_left).offset(-marginWith/2 *SCALEX);
    }];

    // 控制台按钮的view
    UIView *rightConsoleView = [[UIView alloc] init];
    self.rightConsole = rightConsoleView;
    [self.rightViewContrainer addSubview:rightConsoleView];
    [rightConsoleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewHeight*SCALEX, folatViewHeight*SCALEY));
        make.right.mas_equalTo(rightline2).offset(-marginWith/2 *SCALEX);
        make.top.mas_equalTo(self.rightViewContrainer.mas_top);
    }];
    // 控制台按钮图标
    UIImageView *rightConsoleIcon = [UIViewHelper makeImageView:@"ic_console.png"
                                                          width:folatViewHeight/2*SCALEY
                                                         height:folatViewHeight/2*SCALEY];
    [rightConsoleView addSubview:rightConsoleIcon];
    [rightConsoleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(rightConsoleView.mas_centerX);
        make.top.mas_equalTo(rightConsoleView.mas_top).offset(padding*SCALEY);
    }];
    // 控制台按钮文字标签
    UILabel *rightConsoleLabel = [[UILabel alloc] init];
    rightConsoleLabel.font = [UIFont systemFontOfSize:12.0*SCALEY];
    rightConsoleLabel.text=@"控制台";
    [rightConsoleView addSubview:rightConsoleLabel];
    [rightConsoleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(rightConsoleView.mas_bottom).offset(-padding*SCALEY);
        make.height.mas_equalTo(16*SCALEY);
        make.centerX.mas_equalTo(rightConsoleView.mas_centerX);
    }];
    
    // 添加上屏幕并添加约束
    UIWindow *lastWindow = [UIApplication sharedApplication].keyWindow;
    [lastWindow addSubview:self.leftViewContrainer];
    [lastWindow addSubview:self.rightViewContrainer];
    [lastWindow addSubview:self.mainImageButton];
    
    [self.leftViewContrainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mainImageButton.mas_left);
        make.top.mas_equalTo(self.mainImageButton.mas_top);
    }];
    
    [self.rightViewContrainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mainImageButton.mas_right);
        make.top.mas_equalTo(self.mainImageButton.mas_top);
    }];
}

- (void)initEvent
{
    // 设置浮动按钮监听
    _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
    _pan.delaysTouchesBegan = NO;
    [_mainImageButton addGestureRecognizer:_pan];
    
    // 设置退出按钮监听
    [self.leftLogout addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutOnClick:)]];
    [self.rightLogout addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutOnClick:)]];
    
    // 设置刷新按钮监听
    [self.leftRefresh addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshOnClick:)]];
    [self.rightRefresh addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshOnClick:)]];
    
    // 设置控制台按钮
    [self.leftConsole addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(consoleOnClick:)]];
    [self.rightConsole addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(consoleOnClick:)]];
}

- (void)showWindow
{
    [self.mainImageButton setAlpha:1.0];
    [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
}

- (void)dissmissWindow{
    self.isOpen = NO;
    [self.mainImageButton setAlpha:0.0];
    [self.leftViewContrainer setAlpha:0.0];
    [self.rightViewContrainer setAlpha:0.0];
}

-(void)setOnClickListener:(ConsoleBlock)consoleBlock
                  refresh:(RefreshBlock)refreshBlock
                   logout:(LogoutBlock)logoutBlock
{
    self.consoleBlock = consoleBlock;
    self.refreshBlock = refreshBlock;
    self.logoutBlock = logoutBlock;
}

- (void)changBoundsabovePanPoint:(CGPoint)panPoint{
    // 设置y方向不可隐藏
    if (panPoint.y<(folatViewHeight*SCALEY)/2 || panPoint.y>kScreenHeight-(folatViewHeight*SCALEY)/2) {
        if(panPoint.y<(folatViewHeight*SCALEY)/2){
            panPoint.y=(folatViewHeight*SCALEY)/2;
        }else{
            panPoint.y=kScreenHeight-(folatViewHeight*SCALEY)/2;
        }
    }
    
    if(panPoint.x <= kScreenWidth/2)
    {
        [UIView animateWithDuration:animateDuration animations:^{
            self.mainImageButton.center = CGPointMake((folatViewHeight*SCALEY)/2, panPoint.y);
        }];
    }
    else
    {
        [UIView animateWithDuration:animateDuration animations:^{
            self.mainImageButton.center = CGPointMake(kScreenWidth-(folatViewHeight*SCALEY)/2, panPoint.y);
        }];
    }
}

// 改变位置
- (void)locationChange:(UIPanGestureRecognizer*)p
{
    if(self.isOpen) return;
    
    CGPoint panPoint = [p locationInView:[UIApplication sharedApplication].keyWindow];
    
    if(p.state == UIGestureRecognizerStateBegan)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeStatus) object:nil];
        _mainImageButton.alpha = normalAlpha;
    }
    if(p.state == UIGestureRecognizerStateChanged)
    {
        self.mainImageButton.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(p.state == UIGestureRecognizerStateEnded)
    {
        [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
        [self changBoundsabovePanPoint:panPoint];
    }
}

// 点击事件
- (void)click:(id)sender
{
    UIView *animeView;
    if(self.mainImageButton.center.x <= kScreenWidth/2)//判断是哪一边
    {
        // 左
        animeView = self.leftViewContrainer;
        // 恢复位置
        self.mainImageButton.center = CGPointMake((folatViewHeight*SCALEY)/2, self.mainImageButton.center.y);
    }else{
        // 右
        animeView = self.rightViewContrainer;
        // 恢复位置
        self.mainImageButton.center = CGPointMake(kScreenWidth-(folatViewHeight*SCALEY)/2, self.mainImageButton.center.y);
    }
    
    self.mainImageButton.alpha = normalAlpha;
    // 判断是打开还是关闭
    if (self.isOpen) {
        [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
        
        [UIView animateWithDuration:0.1 animations:^{
            [animeView setAlpha:1];
            [animeView setAlpha:0];
            [animeView setTransform:CGAffineTransformMakeScale(0.8, 1)];
        }];
        self.isOpen = NO;
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeStatus) object:nil];
        
        [UIView animateWithDuration:0.3 animations:^{
            [animeView setAlpha:0];
            [animeView setAlpha:1];
            [animeView setTransform:CGAffineTransformMakeScale(1, 1)];
        }];
        self.isOpen = YES;
    }
}

- (void)changeStatus
{
    if (self.isOpen || self.mainImageButton.alpha<=0.1) {
        return;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        _mainImageButton.alpha = sleepAlpha;
    }];
    
    // 判断是哪一边
    if(self.mainImageButton.center.x <= kScreenWidth/2)
    {
        // 左
        [UIView animateWithDuration:animateDuration animations:^{
            self.mainImageButton.center = CGPointMake(0, self.mainImageButton.center.y);
        }];
    }else{
        // 右
        [UIView animateWithDuration:animateDuration animations:^{
            self.mainImageButton.center = CGPointMake(kScreenWidth, self.mainImageButton.center.y);
        }];
    }
}

// 退出的监听事件
-(void)logoutOnClick:(id)sender
{
    NSLog(@"%@", sender);
    self.logoutBlock();
}

// 刷新的监听事件
-(void)refreshOnClick:(id)sender
{
    self.refreshBlock();
}

// 控制台的监听事件
-(void)consoleOnClick:(id)sender
{
    self.consoleBlock();
}

/**
 * 以下为单例代码
 */
static FloatingButtonWindowManage *_instace;

+(instancetype)defaultManagerWithImageName:(NSString *)name
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instace ==nil) {
            _instace=[[FloatingButtonWindowManage alloc]initWithImageName:name];
        }
    });
    
    return _instace;
}

@end
