#import <objc/runtime.h>

#import "RTNMarkdown.h"
#import "RTNMarkdownComponentView.h"
#import "RTNMarkdownLayoutHelper.h"

#import <react/renderer/components/RTNMarkdownSpecs/ComponentDescriptors.h>
#import <react/renderer/components/RTNMarkdownSpecs/EventEmitters.h>
#import <react/renderer/components/RTNMarkdownSpecs/Props.h>
#import <react/renderer/components/RTNMarkdownSpecs/RCTComponentViewHelpers.h>

#import <React/RCTBackedTextInputViewProtocol.h>
#import <React/RCTTextInputComponentView.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@interface RTNMarkdown () <RCTRTNMarkdownViewProtocol>
@end

@implementation RTNMarkdown {
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

  CALayer *markdownLayer = [CALayer new];
  [backedTextInputView.layer addSublayer:markdownLayer];
  [childMarkdownComponentView setMarkdownLayer:markdownLayer];

  [childMarkdownComponentView
      setLayoutHelper:[[RTNMarkdownLayoutHelper alloc]
                          initWithTextInputView:backedTextInputView]];

  [super mountChildComponentView:childMarkdownComponentView index:index];
}

@end

Class<RCTComponentViewProtocol> RTNMarkdownCls(void) {
  return RTNMarkdown.class;
}
