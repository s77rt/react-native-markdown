#import "RTNMarkdownBlockquoteLayoutFragment.h"

@interface RTNMarkdownBlockquoteLayoutFragment ()
@end

@implementation RTNMarkdownBlockquoteLayoutFragment {
}

- (CGRect)renderingSurfaceBounds {
  UIEdgeInsets insets = UIEdgeInsetsMake(
      0, -(self.gapWidth + self.stripeWidth) * self.indentationLevel, 0, 0);
  return UIEdgeInsetsInsetRect(super.renderingSurfaceBounds, insets);
}

- (void)drawAtPoint:(CGPoint)point inContext:(CGContextRef)context {
  [super drawAtPoint:point inContext:context];

  CGFloat stripeHeight = 0;
  for (NSTextLineFragment *textLineFragment in self.textLineFragments) {
    if (textLineFragment.characterRange.length == 0) {
      continue;
    }
    stripeHeight += textLineFragment.typographicBounds.size.height;
  }

  for (int i = 1; i <= self.indentationLevel; i++) {
    CGRect rectangle = CGRectMake(-(self.gapWidth + self.stripeWidth) * i, 0,
                                  self.stripeWidth, stripeHeight);
    CGContextSetFillColorWithColor(context, [self.stripeColor CGColor]);
    CGContextFillRect(context, rectangle);
  }
}

@end
