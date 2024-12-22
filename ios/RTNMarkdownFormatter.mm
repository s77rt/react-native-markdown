#import "RTNMarkdownFormatter.h"
#import <stdio.h>
// TODO remove stdio import

static int enter_block_callback(MD_BLOCKTYPE type, void *detail,
                                void *userdata) {
  CommonMarkTextInputData *r = (CommonMarkTextInputData *)userdata;
  r->blockStack.push_back((BlockNode){type, 0, 0});
  return 0;
}
static int leave_block_callback(MD_BLOCKTYPE type, void *detail,
                                void *userdata) {
  CommonMarkTextInputData *r = (CommonMarkTextInputData *)userdata;
  BlockNode block = r->blockStack.back();
  printf("leaving block %d - start: %d - end: %d - indent level: %d\n",
         block.type, block.start, block.end, r->blockStack.size() - 1);
  if (block.type == MD_BLOCK_QUOTE) {
    if ((r->blockStack.size() - 1) % 2 == 0) {
      [r->result
          addAttributes:@{NSBackgroundColorAttributeName : [UIColor blueColor]}
                  range:NSMakeRange(block.start, block.end - block.start)];
    } else {
      [r->result
          addAttributes:@{
            NSBackgroundColorAttributeName : [UIColor yellowColor]
          }
                  range:NSMakeRange(block.start, block.end - block.start)];
    }
  }
  r->blockStack.pop_back();
  return 0;
}
static int enter_span_callback(MD_SPANTYPE type, void *detail, void *userdata) {
  CommonMarkTextInputData *r = (CommonMarkTextInputData *)userdata;
  r->spanStack.push_back((SpanNode)type);
  return 0;
}
static int leave_span_callback(MD_SPANTYPE type, void *detail, void *userdata) {
  CommonMarkTextInputData *r = (CommonMarkTextInputData *)userdata;
  r->spanStack.pop_back();
  return 0;
}
static int text_callback(MD_TEXTTYPE type, const MD_CHAR *text,
                         MD_OFFSET offset, MD_SIZE size, MD_OFFSET offset_char,
                         MD_SIZE size_char, void *userdata) {
  CommonMarkTextInputData *r = (CommonMarkTextInputData *)userdata;

  // The received range may be out of bounds because MD4C adds extra newlines
  // (e.g. after HTML tags)
  if (offset_char + size_char > r->inputLength) {
    return 0;
  }

  for (BlockNode &block : r->blockStack) {
    if (block.start == 0 && block.end == 0) {
      block.start = offset_char;
    }
    block.end = offset_char + size_char;
  }

  NSMutableDictionary<NSAttributedStringKey, id> *attributes =
      [[NSMutableDictionary alloc] initWithCapacity:r->spanStack.size()];
  // TODO remove (syntax test)
  [attributes setValue:[UIColor blackColor]
                forKey:NSForegroundColorAttributeName];
  for (const SpanNode &span : r->spanStack) {
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
  [r->result addAttributes:attributes
                     range:NSMakeRange(offset_char, size_char)];

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
      backedTextInputView.attributedText.string.length, output};

  [output beginEditing];
  // TODO remove (syntax test)
  [output
      addAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}
              range:NSMakeRange(
                        0, backedTextInputView.attributedText.string.length)];
  md_parse(input, strlen(input), &parser, &userdata);
  [output endEditing];

  return output;
}
