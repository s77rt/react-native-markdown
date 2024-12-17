#import <objc/runtime.h>

#import "RTNMarkdownInput.h"

#import <react/renderer/components/RTNMarkdownInputSpecs/ComponentDescriptors.h>
#import <react/renderer/components/RTNMarkdownInputSpecs/EventEmitters.h>
#import <react/renderer/components/RTNMarkdownInputSpecs/Props.h>
#import <react/renderer/components/RTNMarkdownInputSpecs/RCTComponentViewHelpers.h>

#import <React/RCTTextInputComponentView.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@interface RTNMarkdownInput () <RCTRTNMarkdownInputViewProtocol>
@end

@implementation RTNMarkdownInput {
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<
      RTNMarkdownInputComponentDescriptor>();
}

- (void)mountChildComponentView:
            (UIView<RCTComponentViewProtocol> *)childComponentView
                          index:(NSInteger)index {
  object_setClass((RCTTextInputComponentView *)childComponentView,
                  objc_getClass("RTNMarkdownInputComponentView"));
  [super mountChildComponentView:childComponentView index:index];
}

@end

Class<RCTComponentViewProtocol> RTNMarkdownInputCls(void) {
  return RTNMarkdownInput.class;
}
