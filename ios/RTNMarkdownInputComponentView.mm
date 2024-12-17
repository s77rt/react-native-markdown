#import "RTNMarkdownInputComponentView.h"

#import <React/RCTBackedTextInputDelegate.h>
#import <React/RCTBackedTextInputViewProtocol.h>

using namespace facebook::react;

// Re-declare the super class interface so we access unexposed methods
@interface RCTTextInputComponentView () <RCTBackedTextInputDelegate>
- (void)textInputDidChange;
- (void)_setAttributedString:(NSAttributedString *)attributedString;
- (void)setTextAndSelection:(NSInteger)eventCount
                      value:(NSString *__nullable)value
                      start:(NSInteger)start
                        end:(NSInteger)end;
@end

@interface RTNMarkdownInputComponentView ()
@end

@implementation RTNMarkdownInputComponentView {
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

- (void)formatText {
  UIView<RCTBackedTextInputViewProtocol> *backedTextInputView =
      [super valueForKey:@"_backedTextInputView"];

  if (backedTextInputView.attributedText.string.length > 4) {
    NSMutableAttributedString *attributedString =
        [[NSMutableAttributedString alloc]
            initWithAttributedString:backedTextInputView.attributedText];
    [attributedString beginEditing];
    [attributedString
        addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}
                range:NSMakeRange(2, 2)];
    [attributedString endEditing];
    [super _setAttributedString:attributedString];
  }
}

@end

Class<RCTComponentViewProtocol> RTNMarkdownInputComponentViewCls(void) {
  return RTNMarkdownInputComponentView.class;
}
