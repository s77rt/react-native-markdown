#import "RTNMarkdownFormatter.h"
#import "RTNMarkdownUITextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTNMarkdownTextContentStorageDelegate
    : NSObject <NSTextContentManagerDelegate>
@property(nonatomic, weak) RTNMarkdownUITextView *textView;
@property(nonatomic, weak) RTNMarkdownFormatter *formatter;
@end

NS_ASSUME_NONNULL_END
