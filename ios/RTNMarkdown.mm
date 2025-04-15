#import <objc/runtime.h>

#import "RTNMarkdown.h"
#import "RTNMarkdownComponentProps.h"
#import "RTNMarkdownFormatter.h"
#import "RTNMarkdownParagraphTextView.h"
#import "RTNMarkdownTextContentStorageDelegate.h"
#import "RTNMarkdownTextLayoutManagerDelegate.h"
#import "RTNMarkdownUITextView.h"

#import <React/RCTBackedTextInputViewProtocol.h>
#import <React/RCTParagraphComponentView.h>
#import <React/RCTTextInputComponentView.h>
#import <React/RCTUITextView.h>

#import <react/renderer/components/RTNMarkdownSpecs/ComponentDescriptors.h>
#import <react/renderer/components/RTNMarkdownSpecs/EventEmitters.h>
#import <react/renderer/components/RTNMarkdownSpecs/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@interface RTNMarkdown () <RCTRTNMarkdownViewProtocol>
@end

@implementation RTNMarkdown {
  UIView<RCTBackedTextInputViewProtocol> *_backedTextInputView; // s77rt TODO
  RTNMarkdownFormatter *_formatter;
  RTNMarkdownTextLayoutManagerDelegate<NSTextLayoutManagerDelegate>
      *_textLayoutManagerDelegate;
  RTNMarkdownTextContentStorageDelegate<NSTextContentStorageDelegate>
      *_textContentStorageDelegate;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RTNMarkdownComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RTNMarkdownProps>();
    _props = defaultProps;

    const auto &defaultViewProps =
        *std::static_pointer_cast<RTNMarkdownProps const>(_props);

    _textLayoutManagerDelegate = [RTNMarkdownTextLayoutManagerDelegate new];
    _textContentStorageDelegate =
        (RTNMarkdownTextContentStorageDelegate<NSTextContentStorageDelegate> *)
            [RTNMarkdownTextContentStorageDelegate new];

    _formatter = [[RTNMarkdownFormatter alloc]
        initWithMarkdownStyles:[RTNMarkdownComponentProps
                                   markdownStyles:defaultViewProps
                                                      .markdownStyles]];
    _textContentStorageDelegate.formatter = _formatter;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props
           oldProps:(Props::Shared const &)oldProps {
  const auto &oldViewProps =
      *std::static_pointer_cast<RTNMarkdownProps const>(_props);
  const auto &newViewProps =
      *std::static_pointer_cast<RTNMarkdownProps const>(props);

  if (![RTNMarkdownComponentProps
          areReactMarkdownStylesEqual:oldViewProps.markdownStyles
                                   to:newViewProps.markdownStyles]) {
    _formatter = [[RTNMarkdownFormatter alloc]
        initWithMarkdownStyles:[RTNMarkdownComponentProps
                                   markdownStyles:newViewProps.markdownStyles]];
    _textContentStorageDelegate.formatter = _formatter;
  }

  [super updateProps:props oldProps:oldProps];
}

- (void)mountChildComponentView:
            (UIView<RCTComponentViewProtocol> *)childComponentView
                          index:(NSInteger)index {
  if ([childComponentView isKindOfClass:[RCTTextInputComponentView class]]) {
    _backedTextInputView =
        [childComponentView valueForKey:@"_backedTextInputView"];

    // Only UITextView (RCTUITextView) exposes a text layout manager
    if ([_backedTextInputView isKindOfClass:[RCTUITextView class]]) {
      object_setClass((RCTUITextView *)_backedTextInputView,
                      objc_getClass("RTNMarkdownUITextView"));

      NSTextLayoutManager *textLayoutManager =
          ((RTNMarkdownUITextView *)_backedTextInputView).textLayoutManager;
      NSTextContentStorage *textContentStorage =
          (NSTextContentStorage *)(textLayoutManager.textContentManager);

      textLayoutManager.delegate = _textLayoutManagerDelegate;
      textContentStorage.delegate = _textContentStorageDelegate;
    }
  } else if ([childComponentView
                 isKindOfClass:[RCTParagraphComponentView class]]) {
    object_setClass([childComponentView valueForKey:@"_textView"],
                    objc_getClass("RTNMarkdownParagraphTextView"));

    NSLog(@"this is a text");
  }

  [super mountChildComponentView:childComponentView index:index];
}

@end

Class<RCTComponentViewProtocol> RTNMarkdownCls(void) {
  return RTNMarkdown.class;
}
