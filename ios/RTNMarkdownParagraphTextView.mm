#import "RTNMarkdownParagraphTextView.h"

@implementation RTNMarkdownParagraphTextView {
  // DO NOT ADD IVARS.
  // This class is used for ISA swizzling.
}

// s77rt should I move state overwritting to the component view?
- (void)drawRect:(CGRect)rect {
  NSLog(@"I got you!");

  auto data = self.state->getData();

  if (data.attributedString.getString().find("s77rt") == std::string::npos) {
    auto fragment = facebook::react::AttributedString::Fragment{};
    fragment.string = "s77rt";

    data.attributedString.appendFragment(std::move(fragment));
    self.state->updateState(std::move(data));

    // updating the state will trigger another drawRect
    return;
  }

  [super drawRect:rect];
}

@end
