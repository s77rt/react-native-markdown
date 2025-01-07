#import "RTNMarkdownTextContentStorageDelegate.h"

@interface RTNMarkdownTextContentStorageDelegate ()
@end

@implementation RTNMarkdownTextContentStorageDelegate {
  NSAttributedString *_previousString;
  NSAttributedString *_previousFormattedString;
}

- (void)setFormatter:(RTNMarkdownFormatter *)formatter {
  if (_formatter != formatter) {
    _formatter = formatter;
    _previousString = nil;
    _previousFormattedString = nil;
  }
}

- (NSTextParagraph *)textContentStorage:
                         (NSTextContentStorage *)textContentStorage
                 textParagraphWithRange:(NSRange)range {
  if (!_formatter) {
    return nil;
  }

  if (_previousString &&
      [_previousString
          isEqualToAttributedString:textContentStorage.attributedString]) {
    return [[NSTextParagraph alloc]
        initWithAttributedString:[_previousFormattedString
                                     attributedSubstringFromRange:range]];
  }

  NSMutableAttributedString *markdownString =
      [textContentStorage.attributedString mutableCopy];

  [markdownString beginEditing];
  [_formatter format:markdownString
      withDefaultTextAttributes:_backedTextInputView.defaultTextAttributes];
  [markdownString endEditing];

  _previousString = [textContentStorage.attributedString copy];
  _previousFormattedString = markdownString;

  return [[NSTextParagraph alloc]
      initWithAttributedString:[markdownString
                                   attributedSubstringFromRange:range]];
}

@end
