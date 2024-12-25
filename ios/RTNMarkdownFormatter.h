#import "RTNMarkdownLayoutHelper.h"
#import "md4c.h"
#import <vector>

typedef MD_SPANTYPE SpanNode;
typedef struct BlockNode {
  MD_BLOCKTYPE type;
  NSUInteger location;
  NSUInteger length;
} BlockNode;

typedef struct CommonMarkTextInputData {
  MD_SIZE inputSize;
  NSMutableAttributedString *markdownString;
  CALayer *markdownLayer;
  RTNMarkdownLayoutHelper *layoutHelper;
  std::vector<SpanNode> spanStack;
  std::vector<BlockNode> blockStack;
} CommonMarkTextInputData;

void CommonMarkTextInput(NSMutableAttributedString *markdownString,
                         CALayer *markdownLayer,
                         RTNMarkdownLayoutHelper *layoutHelper);
