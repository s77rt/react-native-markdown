#import "RTNMarkdownTextLayoutManagerDelegate.h"

@interface RTNMarkdownTextLayoutManagerDelegate ()
@end

@implementation RTNMarkdownTextLayoutManagerDelegate {
}

- (NSTextLayoutFragment *)textLayoutManager:
                              (NSTextLayoutManager *)textLayoutManager
              textLayoutFragmentForLocation:(id<NSTextLocation>)location
                              inTextElement:(NSTextElement *)textElement {
  NSLog(@"heloo!!");

  NSLog(@"%@", location);
  NSLog(@"%@", textElement);

  return [[NSTextLayoutFragment alloc]
      initWithTextElement:textElement
                    range:textElement.elementRange];
}

@end