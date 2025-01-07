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

NS_ASSUME_NONNULL_END
