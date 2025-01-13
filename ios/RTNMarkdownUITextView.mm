
#import "RTNMarkdownUITextView.h"

@interface RCTUITextView ()
- (void)textDidChange;
@end

@implementation RTNMarkdownUITextView {
  // DO NOT ADD IVARS.
  // This class is used for ISA swizzling.
}

- (void)textDidChange {
  [super textDidChange];

  NSTextLayoutManager *textLayoutManager = self.textLayoutManager;
  NSTextContentStorage *textContentStorage =
      (NSTextContentStorage *)(textLayoutManager.textContentManager);

  // A single character can format the whole document e.g. adding "`"
  // to close a code block. Thus we invalidte the layout for the whole
  // document range.
  //
  // PS: Ideally we invalidate only ranges that the markdown parses touches but
  // I'm not sure if invaliding many small ranges is any better than making a
  // single invalidation for the whole range.

  [textContentStorage
      processEditingForTextStorage:textContentStorage.attributedString
                            edited:NSTextStorageEditedAttributes
                             range:(NSRange){0, 0}
                    changeInLength:0
                  invalidatedRange:(NSRange){0, textContentStorage
                                                    .attributedString.length}];

  [textLayoutManager ensureLayoutForRange:textContentStorage.documentRange];
}

@end
