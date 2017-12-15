#import <Foundation/Foundation.h>

typedef void(^LogoutBlock)(void);
typedef void(^RefreshBlock)(void);
typedef void(^ConsoleBlock)(void);

@interface FloatingButtonWindowManage : NSObject

+(instancetype)defaultManagerWithImageName:(NSString*)name;

// 显示（默认）
- (void)showWindow;
// 隐藏
- (void)dissmissWindow;
// 添加监听事件
-(void)setOnClickListener:(ConsoleBlock)consoleBlock
                  refresh:(RefreshBlock)refreshBlock
                   logout:(LogoutBlock)logoutBlock;

@property (nonatomic,copy)LogoutBlock logoutBlock;
@property (nonatomic,copy)RefreshBlock refreshBlock;
@property (nonatomic,copy)ConsoleBlock consoleBlock;

@end
