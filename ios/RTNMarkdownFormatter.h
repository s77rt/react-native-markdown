#import "md4c.h"
#import <React/RCTBackedTextInputViewProtocol.h>
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
  std::vector<SpanNode> spanStack;
  std::vector<BlockNode> blockStack;
} CommonMarkTextInputData;

void CommonMarkTextInput(NSMutableAttributedString *markdownString,
                         CALayer *markdownLayer);
