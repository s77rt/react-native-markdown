#import <React/RCTBackedTextInputViewProtocol.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTNMarkdownLayoutHelper : NSObject
- (instancetype)initWithTextInputView:
    (UIView<RCTBackedTextInputViewProtocol> *)backedTextInputView;
- (CGRect)boundingRectForRange:(NSRange)range;
@end

NS_ASSUME_NONNULL_END
