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
  CALayer *markdownLayer = [self markdownLayer];
  RTNMarkdownLayoutHelper *layoutHelper = [self layoutHelper];

  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  markdownLayer.sublayers = nil;
  [markdownString beginEditing];
  CommonMarkTextInput(markdownString, backedTextInputView.defaultTextAttributes,
                      markdownLayer, layoutHelper);
  [markdownString endEditing];
  [CATransaction commit];

  [super _setAttributedString:markdownString];
}

- (CALayer *)markdownLayer {
  return objc_getAssociatedObject(self, @selector(markdownLayer));
}

- (void)setMarkdownLayer:(CALayer *)value {
  objc_setAssociatedObject(self, @selector(markdownLayer), value,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RTNMarkdownLayoutHelper *)layoutHelper {
  return objc_getAssociatedObject(self, @selector(layoutHelper));
}

- (void)setLayoutHelper:(RTNMarkdownLayoutHelper *)value {
  objc_setAssociatedObject(self, @selector(layoutHelper), value,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

Class<RCTComponentViewProtocol> RTNMarkdownComponentViewCls(void) {
  return RTNMarkdownComponentView.class;
}
