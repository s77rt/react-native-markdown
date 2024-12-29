#import "RTNMarkdownTextLayoutManagerDelegate.h"
#import "RTNMarkdownAttributes.h"
#import "RTNMarkdownBlockquoteLayoutFragment.h"

@interface RTNMarkdownTextLayoutManagerDelegate ()
@end

@implementation RTNMarkdownTextLayoutManagerDelegate {
}

- (NSTextLayoutFragment *)textLayoutManager:
                              (NSTextLayoutManager *)textLayoutManager
              textLayoutFragmentForLocation:(id<NSTextLocation>)location
                              inTextElement:(NSTextElement *)textElement {

  if (!textElement.elementRange.empty &&
      [textElement isKindOfClass:[NSTextParagraph class]]) {
    RTNMarkdownBlockquoteStyle *blockquoteStyle =
        [((NSTextParagraph *)textElement).attributedString
                 attribute:RTNMarkdownBlockquoteStyleAttributeName
                   atIndex:0
            effectiveRange:nil];

    if (blockquoteStyle != nil) {
      RTNMarkdownBlockquoteLayoutFragment *layoutFragment =
          [[RTNMarkdownBlockquoteLayoutFragment alloc]
              initWithTextElement:textElement
                            range:textElement.elementRange];

      layoutFragment.indentationLevel = blockquoteStyle.indentationLevel;
      layoutFragment.gapWidth = blockquoteStyle.gapWidth;
      layoutFragment.stripeWidth = blockquoteStyle.stripeWidth;
      layoutFragment.stripeColor = blockquoteStyle.stripeColor;

      return layoutFragment;
    }
  }

  return [[NSTextLayoutFragment alloc]
      initWithTextElement:textElement
                    range:textElement.elementRange];
}

@end
