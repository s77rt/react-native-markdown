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
static int text_callback(MD_TEXTTYPE type, const MD_CHAR *text, MD_SIZE size,
                         void *userdata) {
  CommonMarkTextInputData *r = (CommonMarkTextInputData *)userdata;
  printf("%s\n", text);
  for (const MD_SPANTYPE &span : r->spanStack) {
    printf("span: %d\n", span);
  }
  return 0;
}

void CommonMarkTextInput(
    UIView<RCTBackedTextInputViewProtocol> *backedTextInputView) {

  MD_PARSER parser = {0,
                      0,
                      enter_block_callback,
                      leave_block_callback,
                      enter_span_callback,
                      leave_span_callback,
                      text_callback,
                      NULL,
                      NULL};
  CommonMarkTextInputData userdata = {};

  md_parse("*test abc* **this should be in bold** _iii_", 43, &parser,
           &userdata);
}
