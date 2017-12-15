#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCALEX [UIScreenHelper shareInstance].autoSizeScaleX
#define SCALEY [UIScreenHelper shareInstance].autoSizeScaleY

@interface UIScreenHelper : NSObject

+(instancetype)shareInstance;

@property(assign,nonatomic)CGFloat autoSizeScaleX;

@property(assign,nonatomic)CGFloat autoSizeScaleY;

@property(assign,nonatomic)NSInteger currentScreenWidth;//记录当前宽度

@end
