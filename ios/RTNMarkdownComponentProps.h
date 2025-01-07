#import <react/renderer/components/RTNMarkdownSpecs/Props.h>

@interface RTNMarkdownComponentProps : NSObject
+ (BOOL)areReactMarkdownStylesEqual:
            (facebook::react::RTNMarkdownMarkdownStylesStruct)lhs
                                 to:(facebook::react::
                                         RTNMarkdownMarkdownStylesStruct)rhs;
+ (NSDictionary<NSString *, NSDictionary<NSString *, id> *> *)markdownStyles:
    (facebook::react::RTNMarkdownMarkdownStylesStruct)reactMarkdownStyles;
@end
