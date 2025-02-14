#import "RTNMarkdownFormatter.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTNMarkdownTextContentStorageDelegate
    : NSObject <NSTextContentManagerDelegate>
@property(nonatomic, weak) RTNMarkdownFormatter *formatter;
@end

NS_ASSUME_NONNULL_END
