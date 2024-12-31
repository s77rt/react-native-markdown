#include "md4c.h"
#include <vector>

typedef struct BlockNode {
  MD_BLOCKTYPE type;
  unsigned location;
  unsigned length;
  unsigned attributeIndex;
  unsigned data1; /* Generic field:
                     Attribute_Heading_Block: heading level
                     Attribute_Heading: heading level
                     Attribute_Blockquote_Block: indentation level
                     Attribute_Blockquote: indentation level
                  */
} BlockNode;

typedef MD_SPANTYPE SpanNode;

typedef enum Attribute {
  Attribute_Unknown = 0,

  Attribute_Document_Block,
  Attribute_Document,

  Attribute_Heading_Block,
  Attribute_Heading,

  Attribute_Blockquote_Block,
  Attribute_Blockquote,

  Attribute_Code_Block,
  Attribute_Code,

  Attribute_HorizontalLine_Block,
  Attribute_HorizontalLine,

  Attribute_Bold,
  Attribute_Italic,
  Attribute_Link,
  Attribute_Image,
  Attribute_InlineCode,
  Attribute_Strikethrough,
  Attribute_Underline,
} Attribute;

typedef struct AttributeFeature {
  Attribute attribute;
  unsigned location;
  unsigned length;
  unsigned data1; /* Generic field:
                     Attribute_Heading_Block: heading level
                     Attribute_Heading: heading level
                     Attribute_Blockquote_Block: indentation level
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

std::vector<AttributeFeature> parse(const char *input);
