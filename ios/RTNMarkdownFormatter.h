NS_ASSUME_NONNULL_BEGIN

@interface RTNMarkdownFormatter : NSObject
- (void)format:(NSMutableAttributedString *)markdownString
    withDefaultTextAttributes:
        (NSDictionary<NSString *, id> *)defaultTextAttributes;
@end

NS_ASSUME_NONNULL_END
