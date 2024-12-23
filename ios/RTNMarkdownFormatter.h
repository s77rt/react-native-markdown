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
  NSMutableAttributedString *result;
  std::vector<SpanNode> spanStack;
  std::vector<BlockNode> blockStack;
} CommonMarkTextInputData;

NSAttributedString *CommonMarkTextInput(
    UIView<RCTBackedTextInputViewProtocol> *backedTextInputView);
