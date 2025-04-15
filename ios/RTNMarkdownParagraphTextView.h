#import <react/renderer/components/text/ParagraphComponentDescriptor.h>

NS_ASSUME_NONNULL_BEGIN

// Defined here but not exported. Redefine
// https://github.com/facebook/react-native/blob/b028f842333445027f0a4d8c87b429aefcec7239/packages/react-native/React/Fabric/Mounting/ComponentViews/Text/RCTParagraphComponentView.mm#L27C1-L35
//
// ParagraphTextView is an auxiliary view we set as contentView so the drawing
// can happen on top of the layers manipulated by RCTViewComponentView (the
// parent view)
@interface RCTParagraphTextView : UIView

@property(nonatomic)
    facebook::react::ParagraphShadowNode::ConcreteState::Shared state;
@property(nonatomic) facebook::react::ParagraphAttributes paragraphAttributes;
@property(nonatomic) facebook::react::LayoutMetrics layoutMetrics;

@end

@interface RTNMarkdownParagraphTextView : RCTParagraphTextView
@end

NS_ASSUME_NONNULL_END
