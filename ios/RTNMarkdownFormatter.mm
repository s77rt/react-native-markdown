#import "RTNMarkdownFormatter.h"
#import "RTNMarkdownAttributes.h"
#import "parser.h"

@implementation RTNMarkdownFormatter {
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

    NSRange range = NSMakeRange(attribute.location, attribute.length);

    switch (attribute.attribute) {
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
      [markdownString addAttribute:RTNMarkdownBlockquoteStyleAttributeName
                             value:blockquoteStyle
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
    }
  }
}

@end
