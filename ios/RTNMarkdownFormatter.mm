#import "RTNMarkdownFormatter.h"
#import <stdio.h>
// TODO remove stdio import

static int enter_block_callback(MD_BLOCKTYPE type, void *detail,
                                void *userdata) {
  CommonMarkTextInputData *r = (CommonMarkTextInputData *)userdata;

  r->blockStack.push_back((BlockNode){type, 0, 0, r->attributesStack.size()});

  NSMutableDictionary<NSAttributedStringKey, id> *attributes =
      [NSMutableDictionary dictionaryWithCapacity:5];

  switch (type) {
  case MD_BLOCK_QUOTE: {
    r->blockQuoteIndentation++;

    NSParagraphStyle *defaultParagraphStyle =
        r->defaultTextAttributes[NSParagraphStyleAttributeName];
    NSMutableParagraphStyle *paragraphStyle =
        defaultParagraphStyle != nil ? [defaultParagraphStyle mutableCopy]
                                     : [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 20 * r->blockQuoteIndentation;
    paragraphStyle.headIndent = 20 * r->blockQuoteIndentation;
    paragraphStyle.tailIndent = 80; // ?
    [attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [attributes setValue:[UIColor yellowColor]
                  forKey:NSBackgroundColorAttributeName];
    [attributes setValue:[UIFont boldSystemFontOfSize:26]
                  forKey:NSFontAttributeName];
    break;
  }
  case MD_BLOCK_CODE: {
    [attributes setValue:[UIFont monospacedSystemFontOfSize:16
                                                     weight:UIFontWeightRegular]
                  forKey:NSFontAttributeName];
    break;
  }
  }

  r->attributesStack.push_back((AttributesPack){attributes, 0, 0});

  return 0;
}

static int leave_block_callback(MD_BLOCKTYPE type, void *detail,
                                void *userdata) {
  CommonMarkTextInputData *r = (CommonMarkTextInputData *)userdata;

  BlockNode block = r->blockStack.back();
  r->attributesStack[block.attributesPackIndex].location = block.location;
  r->attributesStack[block.attributesPackIndex].length = block.length;

  switch (type) {
  case MD_BLOCK_QUOTE:
    CGRect blockRect = [r->layoutHelper
        boundingRectForRange:NSMakeRange(block.location, block.length)];
    CALayer *stripe = [CALayer new];
    stripe.frame =
        CGRectMake(blockRect.origin.x, blockRect.origin.y,
                   10 * r->blockQuoteIndentation, blockRect.size.height);
    stripe.backgroundColor = [UIColor blackColor].CGColor;
    [r->markdownLayer addSublayer:stripe];

    r->blockQuoteIndentation--;
    break;
  }

  r->blockStack.pop_back();

  return 0;
}

// TODO Fix single line input: paragraph style stuck

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

  NSMutableDictionary<NSAttributedStringKey, id> *attributes =
      [NSMutableDictionary dictionaryWithCapacity:5];

  for (BlockNode &block : r->blockStack) {
    if (block.location == 0 && block.length == 0) {
      block.location = line_open;
    }
    block.length = line_close - block.location + 1;

    switch (block.type) {
    case MD_BLOCK_H:
      [attributes setValue:[UIColor blueColor]
                    forKey:NSBackgroundColorAttributeName];
      break;
    }
  }

  for (const SpanNode &span : r->spanStack) {
    switch (span) {
    case MD_SPAN_EM:
      [attributes setValue:[UIColor redColor]
                    forKey:NSBackgroundColorAttributeName];
      break;
    case MD_SPAN_STRONG:
      [attributes setValue:[UIColor greenColor]
                    forKey:NSForegroundColorAttributeName];
      break;
    }
  }

  r->attributesStack.push_back(
      (AttributesPack){attributes, offset_char, size_char});

  return 0;
}

void CommonMarkTextInput(NSMutableAttributedString *markdownString,
                         NSDictionary<NSString *, id> *defaultTextAttributes,
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
  CommonMarkTextInputData userdata = {
      inputSize,     markdownString, defaultTextAttributes,
      markdownLayer, layoutHelper,   0};

  md_parse(input, inputSize, &parser, &userdata);

  for (const AttributesPack &attributesPack : userdata.attributesStack) {
    printf("working on attribute at %d + %d\n", attributesPack.location,
           attributesPack.length);
    [markdownString addAttributes:attributesPack.attributes
                            range:NSMakeRange(attributesPack.location,
                                              attributesPack.length)];
  }
}