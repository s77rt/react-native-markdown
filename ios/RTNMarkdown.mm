#import <objc/runtime.h>

#import <UIKit/UIKit.h>

#import "RTNMarkdown.h"
#import "RTNMarkdownComponentProps.h"
#import "RTNMarkdownFormatter.h"
#import "RTNMarkdownTextContentStorageDelegate.h"
#import "RTNMarkdownTextLayoutManagerDelegate.h"

#import <React/RCTBackedTextInputViewProtocol.h>

#import <react/renderer/components/RTNMarkdownSpecs/ComponentDescriptors.h>
#import <react/renderer/components/RTNMarkdownSpecs/EventEmitters.h>
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
  _backedTextInputView =
      [childComponentView valueForKey:@"_backedTextInputView"];

  // Only UITextView exposes a text layout manager
  if ([_backedTextInputView isKindOfClass:[UITextView class]]) {
    UITextView *textView = (UITextView *)_backedTextInputView;
    NSTextLayoutManager *textLayoutManager = textView.textLayoutManager;
    NSTextContentStorage *textContentStorage =
        (NSTextContentStorage *)textLayoutManager.textContentManager;

    _textContentStorageDelegate.backedTextInputView = _backedTextInputView;

    textLayoutManager.delegate = _textLayoutManagerDelegate;
    textContentStorage.delegate = _textContentStorageDelegate;
  }

  [super mountChildComponentView:childComponentView index:index];
}

@end

Class<RCTComponentViewProtocol> RTNMarkdownCls(void) {
  return RTNMarkdown.class;
}
