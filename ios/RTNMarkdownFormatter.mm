#import "RTNMarkdownFormatter.h"
#import <stdio.h>

static int enter_block_callback(MD_BLOCKTYPE type, void *detail,
                                void *userdata) {
  return 0;
}
static int leave_block_callback(MD_BLOCKTYPE type, void *detail,
                                void *userdata) {
  return 0;
}
static int enter_span_callback(MD_SPANTYPE type, void *detail, void *userdata) {
  CommonMarkTextInputData *r = (CommonMarkTextInputData *)userdata;
  r->spanStack.push_back(type);
  return 0;
}
static int leave_span_callback(MD_SPANTYPE type, void *detail, void *userdata) {
  CommonMarkTextInputData *r = (CommonMarkTextInputData *)userdata;
  r->spanStack.pop_back();
  return 0;
}
static int text_callback(MD_TEXTTYPE type, const MD_CHAR *text,
                         MD_OFFSET offset, MD_SIZE size, MD_OFFSET offset_char, MD_SIZE size_char, void *userdata) {
  CommonMarkTextInputData *r = (CommonMarkTextInputData *)userdata;

  char textBuffer[size + 1];
  strncpy(textBuffer, text, size);
  textBuffer[size] = '\0';
  printf("textBuffer: %s - offset: %d - size: %d - type: %d\n", textBuffer,
         offset_char, size_char, type);

  // The received range may be out of bounds because MD4C adds extra newlines
  // (e.g. after HTML tags)
  if (offset_char + size_char > r->inputLength) {
    return 0;
  }

  NSMutableDictionary<NSAttributedStringKey, id> *attributes =
      [[NSMutableDictionary alloc] initWithCapacity:r->spanStack.size()];

  for (const MD_SPANTYPE &span : r->spanStack) {
    switch (span) {
    case MD_SPAN_EM:
      [attributes setValue:[UIColor redColor]
                    forKey:NSForegroundColorAttributeName];
      break;
    case MD_SPAN_STRONG:
      [attributes setValue:[UIColor greenColor]
                    forKey:NSForegroundColorAttributeName];
      break;
    }
  }

  [r->result addAttributes:attributes range:NSMakeRange(offset_char, size_char)];

  return 0;
}

NSAttributedString *CommonMarkTextInput(
    UIView<RCTBackedTextInputViewProtocol> *backedTextInputView) {
  const char *input = [backedTextInputView.attributedText.string UTF8String];
  NSMutableAttributedString *output = [[NSMutableAttributedString alloc]
      initWithString:backedTextInputView.attributedText.string
          attributes:backedTextInputView.defaultTextAttributes];

  MD_PARSER parser = {0,
                      0,
                      enter_block_callback,
                      leave_block_callback,
                      enter_span_callback,
                      leave_span_callback,
                      text_callback,
                      NULL,
                      NULL};
  CommonMarkTextInputData userdata = {
      backedTextInputView.attributedText.string.length, YES, output};

  [output beginEditing];
  md_parse(input, strlen(input), &parser, &userdata);
  [output endEditing];

  return output;
}
