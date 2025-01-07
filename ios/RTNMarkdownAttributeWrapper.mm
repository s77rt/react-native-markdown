#import "RTNMarkdownAttributeWrapper.h"
#import "RTNMarkdownAttributes.h"

#import <React/RCTFont.h>

@implementation RTNMarkdownBoringWrapper {
  id _value;
}

- (instancetype)initWithValue:(id)value {
  if (self = [super init]) {
    _value = value;
  }
  return self;
}

- (id)attributeWith:(NSDictionary<NSString *, id> *)defaultTextAttributes
              data1:(NSUInteger)data1 {
  return _value;
}

@end

@implementation RTNMarkdownUIFontWrapper {
  NSString *_family;
  NSNumber *_size;
  NSString *_weight;
  NSString *_style;
}

- (instancetype)initWithFamily:(NSString *)family
                      withSize:(NSNumber *)size
                    withWeight:(NSString *)weight
                     withStyle:(NSString *)style {
  if (self = [super init]) {
    _family = family;
    _size = size;
    _weight = weight;
    _style = style;
  }
  return self;
}

- (id)attributeWith:(NSDictionary<NSString *, id> *)defaultTextAttributes
              data1:(NSUInteger)data1 {
  UIFont *defaultFont = defaultTextAttributes[NSFontAttributeName];
  UIFont *font = defaultFont != nil
                     ? defaultFont
                     : [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

  return [RCTFont updateFont:font
                  withFamily:_family
                        size:_size
                      weight:_weight
                       style:_style
                     variant:nil
             scaleMultiplier:1];
}

@end
