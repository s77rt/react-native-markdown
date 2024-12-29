NSString *const RTNMarkdownBlockquoteStyleAttributeName =
    @"RTNMarkdownBlockquoteStyleAttributeName";

NS_ASSUME_NONNULL_BEGIN

@interface RTNMarkdownBlockquoteStyle : NSObject
@property(nonatomic, assign) NSUInteger indentationLevel;
@property(nonatomic, assign) CGFloat gapWidth;
@property(nonatomic, assign) CGFloat stripeWidth;
@property(nonatomic, strong) UIColor *stripeColor;
@end

NS_ASSUME_NONNULL_END
