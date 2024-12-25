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
  printf("leaving block %d - location: %d - length: %d - indent level: %d\n",
         block.type, block.location, block.length, r->blockStack.size() - 1);
  if (block.type == MD_BLOCK_QUOTE) {
    NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
    [r->markdownString
        addAttributes:@{NSBackgroundColorAttributeName : [UIColor yellowColor]}
                range:NSMakeRange(block.location, block.length)];
    paragraphStyle.firstLineHeadIndent = 20;
    paragraphStyle.headIndent = 20;
    [r->markdownString
        addAttributes:@{NSParagraphStyleAttributeName : paragraphStyle}
                range:NSMakeRange(block.location, block.length)];
    CALayer *stripe = [CALayer new];
    CGRect blockRect = [r->layoutHelper
        boundingRectForRange:NSMakeRange(block.location, block.length)];
    stripe.frame = (CGRect){blockRect.origin, {10, blockRect.size.height}};
    stripe.backgroundColor = [UIColor blackColor].CGColor;
    [r->markdownLayer addSublayer:stripe];
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
                         MD_SIZE size_char, MD_OFFSET line_open,
                         MD_OFFSET line_close, void *userdata) {
  CommonMarkTextInputData *r = (CommonMarkTextInputData *)userdata;

  // The received range may be out of bounds because MD4C adds extra newlines
  // (e.g. after HTML tags)
  if (offset + size > r->inputSize) {
    return 0;
  }

  char textBuffer[size + 1];
  strncpy(textBuffer, text, size);
  textBuffer[size] = '\0';
  printf("textBuffer: %s - offset: %d (%d) - size: %d (%d) - type: %d\n",
         textBuffer, offset_char, offset, size_char, size, type);

  for (BlockNode &block : r->blockStack) {
    if (block.location == 0 && block.length == 0) {
      block.location = line_open;
    }
    block.length = line_close - block.location + 1;
  }

  NSMutableDictionary<NSAttributedStringKey, id> *attributes =
      [[NSMutableDictionary alloc] initWithCapacity:r->spanStack.size()];
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
  [r->markdownString addAttributes:attributes
                             range:NSMakeRange(offset_char, size_char)];

  return 0;
}

void CommonMarkTextInput(NSMutableAttributedString *markdownString,
                         CALayer *markdownLayer,
                         RTNMarkdownLayoutHelper *layoutHelper) {
  const MD_CHAR *input = [markdownString.string UTF8String];
  const MD_SIZE inputSize = strlen(input);

  MD_PARSER parser = {0,
                      0,
                      enter_block_callback,
                      leave_block_callback,
                      enter_span_callback,
                      leave_span_callback,
                      text_callback,
                      NULL,
                      NULL};
  CommonMarkTextInputData userdata = {inputSize, markdownString, markdownLayer,
                                      layoutHelper};

  md_parse(input, inputSize, &parser, &userdata);
}
