#import <objc/runtime.h>

#import <UIKit/UIKit.h>

#import "RTNMarkdown.h"
#import "RTNMarkdownFormatter.h"
#import "RTNMarkdownTextContentStorageDelegate.h"
#import "RTNMarkdownTextLayoutManagerDelegate.h"

#import <React/RCTBackedTextInputViewProtocol.h>

#import <react/renderer/components/RTNMarkdownSpecs/ComponentDescriptors.h>
#import <react/renderer/components/RTNMarkdownSpecs/EventEmitters.h>
#import <react/renderer/components/RTNMarkdownSpecs/Props.h>
#import <react/renderer/components/RTNMarkdownSpecs/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@interface RTNMarkdown () <RCTRTNMarkdownViewProtocol>
@end

@implementation RTNMarkdown {
  UIView<RCTBackedTextInputViewProtocol> *_backedTextInputView;
  RTNMarkdownFormatter *_formatter;
  RTNMarkdownTextLayoutManagerDelegate<NSTextLayoutManagerDelegate>
      *_textLayoutManagerDelegate;
  RTNMarkdownTextContentStorageDelegate<NSTextContentStorageDelegate>
      *_textContentStorageDelegate;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RTNMarkdownComponentDescriptor>();
}

- (void)mountChildComponentView:
            (UIView<RCTComponentViewProtocol> *)childComponentView
                          index:(NSInteger)index {
  _backedTextInputView =
      [childComponentView valueForKey:@"_backedTextInputView"];

  // Only UITextView exposes a text layout manager
  if ([_backedTextInputView isKindOfClass:[UITextView class]]) {
    UITextView *textView = (UITextView *)_backedTextInputView;
    NSTextLayoutManager *textLayoutManager = textView.textLayoutManager;
    NSTextContentStorage *textContentStorage =
        (NSTextContentStorage *)textLayoutManager.textContentManager;

    _formatter = [RTNMarkdownFormatter new];

    _textLayoutManagerDelegate = [RTNMarkdownTextLayoutManagerDelegate new];

    _textContentStorageDelegate =
        (RTNMarkdownTextContentStorageDelegate<NSTextContentStorageDelegate> *)
            [RTNMarkdownTextContentStorageDelegate new];
    _textContentStorageDelegate.backedTextInputView = _backedTextInputView;
    _textContentStorageDelegate.formatter = _formatter;

    textLayoutManager.delegate = _textLayoutManagerDelegate;
    textContentStorage.delegate = _textContentStorageDelegate;
  }

  [super mountChildComponentView:childComponentView index:index];
}

@end

Class<RCTComponentViewProtocol> RTNMarkdownCls(void) {
  return RTNMarkdown.class;
}
