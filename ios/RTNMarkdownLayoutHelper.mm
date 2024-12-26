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
  UITextPosition *start = [_backedTextInputView
      positionFromPosition:_backedTextInputView.beginningOfDocument
                    offset:range.location];
  UITextPosition *end =
      [_backedTextInputView positionFromPosition:start offset:range.length];
  UITextRange *textRange = [_backedTextInputView textRangeFromPosition:start
                                                            toPosition:end];

  CGRect rect = CGRectNull;
  NSArray<UITextSelectionRect *> *selectionRects =
      [_backedTextInputView selectionRectsForRange:textRange];
  for (UITextSelectionRect *selectionRect in selectionRects) {
    rect = CGRectUnion(rect, selectionRect.rect);
  }

  return rect;
}

@end
