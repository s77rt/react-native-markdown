#import <objc/runtime.h>

#import "RTNMarkdownComponentView.h"

#import <React/RCTBackedTextInputDelegate.h>
#import <React/RCTBackedTextInputViewProtocol.h>

#import "RTNMarkdownFormatter.h"

using namespace facebook::react;

// Re-declare the super class interface so we access unexposed methods
@interface RCTTextInputComponentView () <RCTBackedTextInputDelegate>
- (void)_updateState;
- (void)_updateTypingAttributes;
- (void)_setAttributedString:(NSAttributedString *)attributedString;
@end

@interface RTNMarkdownComponentView ()
@end

@implementation RTNMarkdownComponentView {
  // DO NOT ADD IVARS. This class is used as a direct replacement for
  // RCTTextInputComponentView and cannot hold any additional data.
}

/*
 * The original method is called with outdated attributed strings.
 * Making this a NO-OP until a clear RCA is established or bugs are
 * encountered.
 */
- (void)updateState:(const State::Shared &)state
           oldState:(const State::Shared &)oldState {
  return;
}

- (void)_updateState {
  [self formatText];
  [super _updateState];
}

- (void)_updateTypingAttributes {
  UIView<RCTBackedTextInputViewProtocol> *backedTextInputView =
      [super valueForKey:@"_backedTextInputView"];

  if (backedTextInputView.attributedText.length == 0) {
    backedTextInputView.typingAttributes =
        backedTextInputView.defaultTextAttributes;
    return;
  }

  [super _updateTypingAttributes];
}

- (void)formatText {
  UIView<RCTBackedTextInputViewProtocol> *backedTextInputView =
      [super valueForKey:@"_backedTextInputView"];

  NSMutableAttributedString *markdownString = [[NSMutableAttributedString alloc]
      initWithString:backedTextInputView.attributedText.string
          attributes:backedTextInputView.defaultTextAttributes];

  [markdownString beginEditing];
  CommonMarkTextInput(markdownString,
                      backedTextInputView.defaultTextAttributes);
  [markdownString endEditing];

  [super _setAttributedString:markdownString];
}

@end

Class<RCTComponentViewProtocol> RTNMarkdownComponentViewCls(void) {
  return RTNMarkdownComponentView.class;
}
