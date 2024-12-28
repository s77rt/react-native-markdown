#import <objc/runtime.h>

#import <UIKit/UIKit.h>

#import "RTNMarkdown.h"
#import "RTNMarkdownComponentView.h"
#import "RTNMarkdownTextLayoutManagerDelegate.h"

#import <React/RCTBackedTextInputViewProtocol.h>
#import <React/RCTTextInputComponentView.h>

#import <react/renderer/components/RTNMarkdownSpecs/ComponentDescriptors.h>
#import <react/renderer/components/RTNMarkdownSpecs/EventEmitters.h>
#import <react/renderer/components/RTNMarkdownSpecs/Props.h>
#import <react/renderer/components/RTNMarkdownSpecs/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@interface RTNMarkdown () <RCTRTNMarkdownViewProtocol>
@end

@implementation RTNMarkdown {
  id<NSTextLayoutManagerDelegate> _textLayoutManagerDelegate;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RTNMarkdownComponentDescriptor>();
}

- (void)mountChildComponentView:
            (UIView<RCTComponentViewProtocol> *)childComponentView
                          index:(NSInteger)index {
  object_setClass((RCTTextInputComponentView *)childComponentView,
                  objc_getClass("RTNMarkdownComponentView"));
  RTNMarkdownComponentView *childMarkdownComponentView =
      (RTNMarkdownComponentView *)childComponentView;

  UIView<RCTBackedTextInputViewProtocol> *backedTextInputView =
      [childMarkdownComponentView valueForKey:@"_backedTextInputView"];

  if (@available(iOS 16.0, *)) {
    // Only UITextView exposes a text layout manager
    if ([backedTextInputView isKindOfClass:[UITextView class]]) {
      _textLayoutManagerDelegate = [RTNMarkdownTextLayoutManagerDelegate new];
      ((UITextView *)backedTextInputView).textLayoutManager.delegate =
          _textLayoutManagerDelegate;
    }
  }

  [super mountChildComponentView:childMarkdownComponentView index:index];
}

@end

Class<RCTComponentViewProtocol> RTNMarkdownCls(void) {
  return RTNMarkdown.class;
}
