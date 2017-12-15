#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "UIScreenHelper.h"

#define LINE @"#c5c6c7"         // 线条的颜色
#define BALCK50_TEXT @"#6b6b6c"
#define THEME_TEXT @"#f86900"   // 主题文本颜色

@interface UIViewHelper : NSObject

+(UIImageView *)makeImageView:(NSString *) name
                        width:(CGFloat) width
                       height:(CGFloat) height;

+(UIButton *) makeUIButton:(CGFloat)width
                     high:(CGFloat)high
           NormalImageName:(NSString *)name
         SelectedImageName:(NSString*) sname;

+(UIColor *)RGBStringDecode:(NSString *)rgb;
+(UIColor *)ARGBStringDecode:(NSString *)argb;

@end
