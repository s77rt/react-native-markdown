#import <objc/runtime.h>

#import "RTNMarkdown.h"

#import <react/renderer/components/RTNMarkdownSpecs/ComponentDescriptors.h>
#import <react/renderer/components/RTNMarkdownSpecs/EventEmitters.h>
#import <react/renderer/components/RTNMarkdownSpecs/Props.h>
#import <react/renderer/components/RTNMarkdownSpecs/RCTComponentViewHelpers.h>

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

  // TODO use custom NSTextLayoutManager

  [super mountChildComponentView:childMarkdownComponentView index:index];
}

@end

Class<RCTComponentViewProtocol> RTNMarkdownCls(void) {
  return RTNMarkdown.class;
}
