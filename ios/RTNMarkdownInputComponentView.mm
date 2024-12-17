#import "RTNMarkdownInputComponentView.h"

#import <React/RCTBackedTextInputDelegate.h>
#import <React/RCTBackedTextInputViewProtocol.h>

using namespace facebook::react;

// Re-declare the super class interface so we access the unexposed methods e.g.
// textInputDidChange
@interface RCTTextInputComponentView () <RCTBackedTextInputDelegate>
- (void)textInputDidChange;
- (void)_setAttributedString:(NSAttributedString *)attributedString;
@end

@interface RTNMarkdownInputComponentView ()
@end

@implementation RTNMarkdownInputComponentView {
  UIView<RCTBackedTextInputViewProtocol> *_backedTextInputView;
}

- (void)populateBackedTextInputView {
  _backedTextInputView =
      (UIView<RCTBackedTextInputViewProtocol> *)[super accessibilityElement];
}

- (void)textInputDidChange {
  if (_backedTextInputView.attributedText.string.length > 4) {
    NSMutableAttributedString *attributedString =
        [[NSMutableAttributedString alloc]
            initWithAttributedString:_backedTextInputView.attributedText];
    [attributedString beginEditing];
    [attributedString
        addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}
                range:NSMakeRange(2, 2)];
    [attributedString endEditing];
    [super _setAttributedString:attributedString];
  }
  [super textInputDidChange];
}

@end

Class<RCTComponentViewProtocol> RTNMarkdownInputComponentViewCls(void) {
  return RTNMarkdownInputComponentView.class;
}
