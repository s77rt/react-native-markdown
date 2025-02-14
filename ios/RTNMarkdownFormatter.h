NS_ASSUME_NONNULL_BEGIN

@interface RTNMarkdownFormatter : NSObject
- (instancetype)initWithMarkdownStyles:
    (NSDictionary<NSString *, NSDictionary<NSString *, id> *> *)markdownStyles;
- (void)format:(NSMutableAttributedString *)markdownString;
@end

NS_ASSUME_NONNULL_END
