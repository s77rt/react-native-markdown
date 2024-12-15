#import "RTNMarkdownInputComponentView.h"

#import <React/RCTBackedTextInputDelegate.h>

using namespace facebook::react;

// Re-declare the super class interface so we access the unexposed
// methods e.g. textInputDidChange
@interface RCTTextInputComponentView () <RCTBackedTextInputDelegate>
- (void)textInputDidChange;
@end

@interface RTNMarkdownInputComponentView ()
@end

@implementation RTNMarkdownInputComponentView {
}

- (void)textInputDidChange {
  [super textInputDidChange];
  NSLog(@"textInputDidChange");
}

@end

Class<RCTComponentViewProtocol> RTNMarkdownInputComponentViewCls(void) {
  return RTNMarkdownInputComponentView.class;
}
