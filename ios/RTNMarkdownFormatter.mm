#import "RTNMarkdownFormatter.h"
#import "RTNMarkdownAttributeWrapper.h"
#import "RTNMarkdownAttributes.h"

#import <React/RCTUtils.h>

#import "parser.h"

@implementation RTNMarkdownFormatter {
  NSDictionary<NSString *, NSDictionary<NSAttributedStringKey,
                                        id<RTNMarkdownAttributeWrapper>> *>
      *_attributes;
}

- (instancetype)initWithMarkdownStyles:
    (NSDictionary<NSString *, NSDictionary<NSString *, id> *> *)markdownStyles {
  if (self = [super init]) {
    NSMutableDictionary *attributes =
        [NSMutableDictionary dictionaryWithCapacity:markdownStyles.count];
    for (NSString *styleKey in markdownStyles) {
      NSDictionary<NSString *, id> *styleValue = markdownStyles[styleKey];
      NSDictionary<NSAttributedStringKey, id<RTNMarkdownAttributeWrapper>>
          *stylesAttributes = [NSMutableDictionary new];

      if (styleValue[@"backgroundColor"] != [NSNull null]) {
        [stylesAttributes
            setValue:[[RTNMarkdownBoringWrapper alloc]
                         initWithValue:styleValue[@"backgroundColor"]]
              forKey:NSBackgroundColorAttributeName];
      }
      if (styleValue[@"color"] != [NSNull null]) {
        [stylesAttributes setValue:[[RTNMarkdownBoringWrapper alloc]
                                       initWithValue:styleValue[@"color"]]
                            forKey:NSForegroundColorAttributeName];
      }
      {
        BOOL hasFontFamily = styleValue[@"fontFamily"] != [NSNull null];
        BOOL hasFontSize = styleValue[@"fontSize"] != [NSNull null];
        BOOL hasFontWeight = styleValue[@"fontWeight"] != [NSNull null];
        BOOL hasFontStyle = styleValue[@"fontStyle"] != [NSNull null];
        if (hasFontFamily || hasFontSize || hasFontWeight || hasFontStyle) {
          NSString *family = hasFontFamily ? styleValue[@"fontFamily"] : nil;
          NSNumber *size = hasFontSize ? styleValue[@"fontSize"] : nil;
          NSString *weight = hasFontWeight ? styleValue[@"fontWeight"] : nil;
          NSString *style = hasFontStyle ? styleValue[@"fontStyle"] : nil;
          [stylesAttributes
              setValue:[[RTNMarkdownUIFontWrapper alloc] initWithFamily:family
                                                               withSize:size
                                                             withWeight:weight
                                                              withStyle:style]
                forKey:NSFontAttributeName];
        }
      }

      if (stylesAttributes.count == 0) {
        continue;
      }

      [attributes setValue:stylesAttributes forKey:styleKey];
    }
    _attributes = attributes;
  }
  return self;
}

- (void)format:(NSMutableAttributedString *)markdownString
    withDefaultTextAttributes:
        (NSDictionary<NSString *, id> *)defaultTextAttributes {
  NSData *input = [markdownString.string
      dataUsingEncoding:NSUTF16LittleEndianStringEncoding];
  const unsigned inputSize = markdownString.string.length;

  std::vector<AttributeFeature> attributes =
      parse((wchar_t *)input.bytes, inputSize);

  for (const AttributeFeature &attribute : attributes) {
    if (attribute.length == 0) {
      continue;
    }
    if (attribute.attribute == Attribute_Unknown) {
      continue;
    }

    NSString *styleKey;
    switch (attribute.attribute) {
    case Attribute_Heading: {
      switch (attribute.data1) {
      case 1:
        styleKey = @"h1";
        break;
      case 2:
        styleKey = @"h2";
        break;
      case 3:
        styleKey = @"h3";
        break;
      case 4:
        styleKey = @"h4";
        break;
      case 5:
        styleKey = @"h5";
        break;
      case 6:
        styleKey = @"h6";
        break;
      default:
        styleKey = @"";
        break;
      };
      break;
    }
    case Attribute_Blockquote:
      styleKey = @"blockquote";
      break;
    case Attribute_Codeblock:
      styleKey = @"codeblock";
      break;
    case Attribute_HorizontalRule:
      styleKey = @"horizontalRule";
      break;
    case Attribute_Bold:
      styleKey = @"bold";
      break;
    case Attribute_Italic:
      styleKey = @"italic";
      break;
    case Attribute_Link:
      styleKey = @"link";
      break;
    case Attribute_Image:
      styleKey = @"image";
      break;
    case Attribute_Code:
      styleKey = @"code";
      break;
    case Attribute_Strikethrough:
      styleKey = @"strikethrough";
      break;
    case Attribute_Underline:
      styleKey = @"underline";
      break;
    default:
      styleKey = @"";
    };

    NSDictionary<NSAttributedStringKey, id<RTNMarkdownAttributeWrapper>>
        *attributes = _attributes[styleKey];
    if (attributes == nil) {
      continue;
    }

    NSRange range = NSMakeRange(attribute.location, attribute.length);

    for (NSAttributedStringKey attributeKey in attributes) {
      [markdownString addAttribute:attributeKey
                             value:[attributes[attributeKey]
                                       attributeWith:defaultTextAttributes
                                               data1:attribute.data1]
                             range:range];
    }

    /*switch (attribute.attribute) {
    case Attribute_Blockquote: {
      NSUInteger indentationLevel = attribute.data1;
      CGFloat gapWidth = 4;
      CGFloat stripeWidth = 4;

      NSParagraphStyle *defaultParagraphStyle =
          defaultTextAttributes[NSParagraphStyleAttributeName];
      NSMutableParagraphStyle *paragraphStyle =
          defaultParagraphStyle != nil ? [defaultParagraphStyle mutableCopy]
                                       : [[NSMutableParagraphStyle alloc] init];
      paragraphStyle.firstLineHeadIndent =
          (gapWidth + stripeWidth) * indentationLevel;
      paragraphStyle.headIndent = (gapWidth + stripeWidth) * indentationLevel;
      [markdownString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:range];

      RTNMarkdownBlockquoteStyle *blockquoteStyle =
          [RTNMarkdownBlockquoteStyle new];
      blockquoteStyle.indentationLevel = indentationLevel;
      blockquoteStyle.gapWidth = gapWidth;
      blockquoteStyle.stripeWidth = stripeWidth;
      blockquoteStyle.stripeColor = [UIColor blueColor];
      [markdownString
          addAttribute:RTNMarkdownBlockquoteStyleAttributeName
                 value:[blockquoteStyle hardCopy:defaultTextAttributes
                                           data1:indentationLevel]
                 range:range];
      break;
    }
    case Attribute_Bold: {
      [markdownString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor greenColor]
                             range:range];
      break;
    }
    case Attribute_Italic: {
      [markdownString addAttribute:NSBackgroundColorAttributeName
                             value:[UIColor redColor]
                             range:range];
      break;
    }
    }*/
  }
}

@end
