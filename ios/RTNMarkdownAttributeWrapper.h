NS_ASSUME_NONNULL_BEGIN

#pragma mark - Protocol

@protocol RTNMarkdownAttributeWrapper
- (id)attributeWith:(NSDictionary<NSString *, id> *)defaultTextAttributes
              data1:(NSUInteger)data1;
@end

#pragma mark - Wrappers

@interface RTNMarkdownBoringWrapper : NSObject <RTNMarkdownAttributeWrapper>
- (instancetype)initWithValue:(id)value;
@end

@interface RTNMarkdownUIFontWrapper : NSObject <RTNMarkdownAttributeWrapper>
- (instancetype)initWithFamily:(NSString *)family
                      withSize:(NSNumber *)size
                    withWeight:(NSString *)weight
                     withStyle:(NSString *)style;
@end

@interface RTNMarkdownBlockquoteParagraphStyleWrapper
    : NSObject <RTNMarkdownAttributeWrapper>
- (instancetype)initWithStripeWidth:(CGFloat)stripeWidth
                       withGapWidth:(CGFloat)gapWidth;
@end

@interface RTNMarkdownBlockquoteStyleWrapper
    : NSObject <RTNMarkdownAttributeWrapper>
- (instancetype)initWithStripeColor:(UIColor *)stripeColor
                    withStripeWidth:(CGFloat)stripeWidth
                       withGapWidth:(CGFloat)gapWidth;
@end

NS_ASSUME_NONNULL_END
