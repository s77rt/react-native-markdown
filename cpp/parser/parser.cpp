#include "parser.h"

static int enter_block_callback(MD_BLOCKTYPE type, void *detail,
                                void *userdata) {
  ParserData *r = (ParserData *)userdata;

  r->blockStack.push_back((BlockNode){
      type, 0, 0, static_cast<unsigned int>(r->attributeStack.size())});

  switch (type) {
  case MD_BLOCK_DOC: {
    r->attributeStack.push_back((AttributeFeature){Attribute_Document, 0, 0});
    break;
  }
  case MD_BLOCK_H: {
    r->attributeStack.push_back((AttributeFeature){
        Attribute_Heading, 0, 0, ((MD_BLOCK_H_DETAIL *)detail)->level});
    break;
  }
  case MD_BLOCK_QUOTE: {
    r->blockquoteIndentationLevel++;
    r->attributeStack.push_back((AttributeFeature){
        Attribute_Blockquote, 0, 0, r->blockquoteIndentationLevel});
    break;
  }
  case MD_BLOCK_CODE: {
    r->attributeStack.push_back((AttributeFeature){Attribute_Codeblock, 0, 0});
    break;
  }
  case MD_BLOCK_HR: {
    r->attributeStack.push_back(
        (AttributeFeature){Attribute_HorizontalRule, 0, 0});
    break;
  }
  default: {
    r->attributeStack.push_back((AttributeFeature){Attribute_Unknown, 0, 0});
  }
  }

  return 0;
}

static int leave_block_callback(MD_BLOCKTYPE type, void *detail,
                                void *userdata) {
  ParserData *r = (ParserData *)userdata;

  BlockNode block = r->blockStack.back();
  r->attributeStack[block.attributeIndex].location = block.location;
  r->attributeStack[block.attributeIndex].length = block.length;

  switch (type) {
  case MD_BLOCK_QUOTE: {
    r->blockquoteIndentationLevel--;
    break;
  }
  default: {
    /* NO-OP */
  }
  }

  r->blockStack.pop_back();

  return 0;
}

static int enter_span_callback(MD_SPANTYPE type, void *detail, void *userdata) {
  ParserData *r = (ParserData *)userdata;
  r->spanStack.push_back((SpanNode)type);
  return 0;
}

static int leave_span_callback(MD_SPANTYPE type, void *detail, void *userdata) {
  ParserData *r = (ParserData *)userdata;
  r->spanStack.pop_back();
  return 0;
}

static int text_callback(MD_TEXTTYPE type, const MD_CHAR *text,
                         MD_OFFSET offset, MD_SIZE size, MD_OFFSET line_open,
                         MD_OFFSET line_close, void *userdata) {
  ParserData *r = (ParserData *)userdata;

  // The received range may be out of bounds because MD4C adds extra newlines
  // (e.g. after HTML tags)
  if (offset + size > r->inputSize) {
    return 0;
  }

  for (BlockNode &block : r->blockStack) {
    if (block.location == 0 && block.length == 0) {
      block.location = line_open;
    }
    block.length = line_close - block.location + 1;
  }

  for (const SpanNode &span : r->spanStack) {
    switch (span) {
    case MD_SPAN_STRONG:
      r->attributeStack.push_back(
          (AttributeFeature){Attribute_Bold, offset, size});
      break;
    case MD_SPAN_EM:
      r->attributeStack.push_back(
          (AttributeFeature){Attribute_Italic, offset, size});
      break;
    case MD_SPAN_A:
      r->attributeStack.push_back(
          (AttributeFeature){Attribute_Link, offset, size});
      break;
    case MD_SPAN_IMG:
      r->attributeStack.push_back(
          (AttributeFeature){Attribute_Image, offset, size});
      break;
    case MD_SPAN_CODE:
      r->attributeStack.push_back(
          (AttributeFeature){Attribute_Code, offset, size});
      break;
    case MD_SPAN_DEL:
      r->attributeStack.push_back(
          (AttributeFeature){Attribute_Strikethrough, offset, size});
      break;
    case MD_SPAN_U:
      r->attributeStack.push_back(
          (AttributeFeature){Attribute_Underline, offset, size});
      break;
    default: {
      /* NO-OP */
    }
    }
  }

  return 0;
}

std::vector<AttributeFeature> parse(const wchar_t *input, unsigned inputSize) {
  MD_PARSER parser = {0,
                      0,
                      enter_block_callback,
                      leave_block_callback,
                      enter_span_callback,
                      leave_span_callback,
                      text_callback,
                      NULL,
                      NULL};
  ParserData parserData = {inputSize, 0};

  md_parse(input, inputSize, &parser, &parserData);

  return parserData.attributeStack;
}
