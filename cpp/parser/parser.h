#ifndef MD4C_USE_UTF16
#define MD4C_USE_UTF16
#endif

#include "md4c.h"

#include <vector>
#include <wchar.h>

typedef struct BlockNode {
  MD_BLOCKTYPE type;
  unsigned location;
  unsigned length;
  unsigned attributeIndex;
} BlockNode;

typedef MD_SPANTYPE SpanNode;

typedef enum Attribute {
  Attribute_Unknown = 0,

  Attribute_Document,
  Attribute_Heading,
  Attribute_Blockquote,
  Attribute_Codeblock,
  Attribute_HorizontalRule,

  Attribute_Bold,
  Attribute_Italic,
  Attribute_Link,
  Attribute_Image,
  Attribute_Code,
  Attribute_Strikethrough,
  Attribute_Underline,
} Attribute;

typedef struct AttributeFeature {
  Attribute attribute;
  unsigned location;
  unsigned length;
  unsigned data1; /* Generic field:
                     Attribute_Heading: heading level
                     Attribute_Blockquote: indentation level
                  */
} AttributeFeature;

typedef struct ParserData {
  unsigned inputSize;
  unsigned blockquoteIndentationLevel;
  std::vector<BlockNode> blockStack;
  std::vector<SpanNode> spanStack;
  std::vector<AttributeFeature> attributeStack;
} ParserData;

std::vector<AttributeFeature> parse(const wchar_t *input, unsigned inputSize);
