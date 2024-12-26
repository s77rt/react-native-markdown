#import "RTNMarkdownLayoutHelper.h"
#import "md4c.h"
#import <vector>

typedef struct BlockNode {
  MD_BLOCKTYPE type;
  NSUInteger location;
  NSUInteger length;
  NSUInteger attributesPackIndex;
} BlockNode;

typedef MD_SPANTYPE SpanNode;

typedef struct AttributesPack {
  NSDictionary<NSAttributedStringKey, id> *attributes;
  NSUInteger location;
  NSUInteger length;
} AttributesPack;

typedef struct CommonMarkTextInputData {
  MD_SIZE inputSize;
  NSMutableAttributedString *markdownString;
  CALayer *markdownLayer;
  RTNMarkdownLayoutHelper *layoutHelper;
  NSUInteger blockQuoteIndentation;
  std::vector<BlockNode> blockStack;
  std::vector<SpanNode> spanStack;
  std::vector<AttributesPack> attributesStack;
} CommonMarkTextInputData;

void CommonMarkTextInput(NSMutableAttributedString *markdownString,
                         CALayer *markdownLayer,
                         RTNMarkdownLayoutHelper *layoutHelper);
