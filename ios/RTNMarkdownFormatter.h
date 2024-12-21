#import "md4c.h"
#import <React/RCTBackedTextInputViewProtocol.h>
#import <vector>

typedef struct CommonMarkTextInputData {
  NSUInteger inputLength;
  BOOL preserveSyntax;
  NSMutableAttributedString *result;
  std::vector<MD_SPANTYPE> spanStack;
} CommonMarkTextInputData;

NSAttributedString *CommonMarkTextInput(
    UIView<RCTBackedTextInputViewProtocol> *backedTextInputView);
