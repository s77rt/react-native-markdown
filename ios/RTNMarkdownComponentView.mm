#import <objc/runtime.h>

#import "RTNMarkdownComponentView.h"

#import <React/RCTBackedTextInputDelegate.h>
#import <React/RCTBackedTextInputViewProtocol.h>

#import "RTNMarkdownFormatter.h"

using namespace facebook::react;

// Re-declare the super class interface so we access unexposed methods
@interface RCTTextInputComponentView () <RCTBackedTextInputDelegate>
- (void)textInputDidChange;
- (void)_setAttributedString:(NSAttributedString *)attributedString;
- (void)setTextAndSelection:(NSInteger)eventCount
                      value:(NSString *__nullable)value
                      start:(NSInteger)start
                        end:(NSInteger)end;
- (void)_updateTypingAttributes;
@end

@interface RTNMarkdownComponentView ()
@end

@implementation RTNMarkdownComponentView {
  // DO NOT ADD IVARS. This class is not meant to be initialized. It's just
  // swapped in place of RCTTextInputComponentView and its instances cannot hold
  // any additional data.
}

/*
 * The original (super) updateState does nothing but make a call to
 * _setAttributedString with default attributes which messes up our format.
 *  Overriding this method is basically an experiment for now.
 *
 * PS: In case controlled input is out of sync, this is the right method to
 * investigate.
 *
 * FIXME: Find better solution
 */
- (void)updateState:(const State::Shared &)state
           oldState:(const State::Shared &)oldState {
  return;
}

- (void)textInputDidChange {
  [self formatText];
  [super textInputDidChange];
}

- (void)setTextAndSelection:(NSInteger)eventCount
                      value:(NSString *__nullable)value
                      start:(NSInteger)start
                        end:(NSInteger)end {
  [super setTextAndSelection:eventCount value:value start:start end:end];
  [self formatText];
}

/*
 * The original method returns early if the string is empty
 * Should this be fixed upstream?
 */
- (void)_updateTypingAttributes {
  UIView<RCTBackedTextInputViewProtocol> *backedTextInputView =
      [super valueForKey:@"_backedTextInputView"];
  if (backedTextInputView.attributedText.length == 0) {
    backedTextInputView.typingAttributes =
        backedTextInputView.defaultTextAttributes;
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
  CommonMarkTextInput(markdownString, markdownLayer, layoutHelper);
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
