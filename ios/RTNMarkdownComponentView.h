#import "RTNMarkdownLayoutHelper.h"
#import <React/RCTTextInputComponentView.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTNMarkdownComponentView : RCTTextInputComponentView
@property(nonatomic, strong) CALayer *markdownLayer;
@property(nonatomic, strong) RTNMarkdownLayoutHelper *layoutHelper;
@end

NS_ASSUME_NONNULL_END
