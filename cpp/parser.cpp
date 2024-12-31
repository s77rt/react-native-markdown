#include "parser.h"

static int enter_block_callback(MD_BLOCKTYPE type, void *detail,
                                void *userdata) {
  ParserData *r = (ParserData *)userdata;

  r->blockStack.push_back((BlockNode){
      type, 0, 0, static_cast<unsigned int>(r->attributeStack.size())});

  switch (type) {
  case MD_BLOCK_QUOTE: {
    r->blockquoteIndentationLevel++;
    r->attributeStack.push_back((AttributeFeature){
        Attribute_Blockquote_Block, 0, 0, r->blockquoteIndentationLevel});
    break;
  }
  case MD_BLOCK_CODE: {
    r->attributeStack.push_back((AttributeFeature){Attribute_Code_Block, 0, 0});
    break;
  }
  case MD_BLOCK_H: {
    r->attributeStack.push_back((AttributeFeature){
        Attribute_Heading_Block, 0, 0, ((MD_BLOCK_H_DETAIL *)detail)->level});
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
  case MD_BLOCK_QUOTE:
    r->blockquoteIndentationLevel--;
    break;
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
                         MD_OFFSET offset, MD_SIZE size, MD_OFFSET offset_char,
                         MD_SIZE size_char, MD_OFFSET line_open,
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

    switch (block.type) {
    case MD_BLOCK_QUOTE:
      r->attributeStack.push_back((AttributeFeature){
          Attribute_Blockquote, offset_char, size_char, block.data1});
      break;
    case MD_BLOCK_CODE:
      r->attributeStack.push_back(
          (AttributeFeature){Attribute_Code, offset_char, size_char});
      break;
    case MD_BLOCK_H:
      r->attributeStack.push_back((AttributeFeature){
          Attribute_Heading, offset_char, size_char, block.data1});
      break;
    }
  }

  for (const SpanNode &span : r->spanStack) {
    switch (span) {
    case MD_SPAN_EM:
      r->attributeStack.push_back(
          (AttributeFeature){Attribute_Italic, offset_char, size_char});
      break;
    case MD_SPAN_STRONG:
      r->attributeStack.push_back(
          (AttributeFeature){Attribute_Bold, offset_char, size_char});
      break;
    }
  }

  return 0;
}

std::vector<AttributeFeature> parse(const char *input) {
  const unsigned inputSize = strlen(input);

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
