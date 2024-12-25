#import "RTNMarkdownLayoutHelper.h"

@interface RTNMarkdownLayoutHelper ()
@end

@implementation RTNMarkdownLayoutHelper {
  __weak UIView<RCTBackedTextInputViewProtocol> *_backedTextInputView;
}

- (instancetype)initWithTextInputView:
    (UIView<RCTBackedTextInputViewProtocol> *)backedTextInputView {
  if (self = [super init]) {
    _backedTextInputView = backedTextInputView;
  }

  return self;
}

- (CGRect)boundingRectForRange:(NSRange)range {
  UITextView *textView = ((UITextView *)_backedTextInputView);
  UITextPosition *start =
      [textView positionFromPosition:textView.beginningOfDocument
                              offset:range.location];
  UITextPosition *end = [textView positionFromPosition:start
                                                offset:range.length];
  UITextRange *textRange = [textView textRangeFromPosition:start
                                                toPosition:end];

  CGRect rect = CGRectNull;
  NSArray<UITextSelectionRect *> *selectionRects =
      [textView selectionRectsForRange:textRange];
  for (UITextSelectionRect *selectionRect in selectionRects) {
    rect = CGRectUnion(rect, selectionRect.rect);
  }

  return rect;
}

@end
