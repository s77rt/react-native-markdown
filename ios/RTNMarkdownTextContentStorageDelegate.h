#import "RTNMarkdownFormatter.h"
#import <React/RCTBackedTextInputViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTNMarkdownTextContentStorageDelegate
    : NSObject <NSTextContentManagerDelegate>
@property(nonatomic, weak)
    UIView<RCTBackedTextInputViewProtocol> *backedTextInputView;
@property(nonatomic, weak) RTNMarkdownFormatter *formatter;
@end

NS_ASSUME_NONNULL_END
