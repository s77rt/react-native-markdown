
#import "RTNMarkdownUITextView.h"

@interface RCTUITextView ()
- (void)textDidChange;
@end

@implementation RTNMarkdownUITextView {
  // DO NOT ADD IVARS.
  // This class is used for ISA swizzling.
}

- (void)invalidateAndLayout {
  NSTextLayoutManager *textLayoutManager = self.textLayoutManager;
  NSTextContentStorage *textContentStorage =
      (NSTextContentStorage *)(textLayoutManager.textContentManager);

  [textContentStorage
      processEditingForTextStorage:textContentStorage.attributedString
                            edited:NSTextStorageEditedAttributes
                             range:(NSRange){0, 0}
                    changeInLength:0
                  invalidatedRange:(NSRange){0, textContentStorage
                                                    .attributedString.length}];

  [textLayoutManager ensureLayoutForRange:textContentStorage.documentRange];
}

- (void)textDidChange {
  [super textDidChange];

  // A single character can format more than one paragraph. However the storage
  // delegate methods will only get called on the changed paragraph. Calling
  // invalidateAndLayout invalidates all the paragraphs causing a complete
  // re-layout.
  [self invalidateAndLayout];
}

@end
