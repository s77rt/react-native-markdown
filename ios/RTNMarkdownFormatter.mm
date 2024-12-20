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
                         MD_OFFSET offset, MD_SIZE size, void *userdata) {
  CommonMarkTextInputData *r = (CommonMarkTextInputData *)userdata;

  for (const MD_SPANTYPE &span : r->spanStack) {
    // printf("span: %d\n", span);
  }

  char textBuffer[size + 1];
  strncpy(textBuffer, text, size);
  textBuffer[size] = '\0';

  printf("textBuffer: %s - offset: %d - size: %d\n", textBuffer, offset, size);

  NSString *textString = [NSString stringWithCString:textBuffer
                                            encoding:NSUTF8StringEncoding];

  // [[r->result mutableString] appendString:textString];

  return 0;
}

NSAttributedString *CommonMarkTextInput(
    UIView<RCTBackedTextInputViewProtocol> *backedTextInputView) {
  const char *input = [backedTextInputView.attributedText.string UTF8String];
  NSMutableAttributedString *output = [[NSMutableAttributedString alloc]
      initWithAttributedString:backedTextInputView.attributedText];

  MD_PARSER parser = {0,
                      0,
                      enter_block_callback,
                      leave_block_callback,
                      enter_span_callback,
                      leave_span_callback,
                      text_callback,
                      NULL,
                      NULL};
  CommonMarkTextInputData userdata = {output, YES};

  [output beginEditing];
  md_parse(input, strlen(input), &parser, &userdata);
  [output endEditing];

  return output;
}
