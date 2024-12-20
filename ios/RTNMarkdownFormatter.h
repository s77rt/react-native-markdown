#import "md4c/md4c.h"
#import <React/RCTBackedTextInputViewProtocol.h>
#import <vector>

typedef struct CommonMarkTextInputData {
  NSMutableAttributedString *result;
  BOOL preserveSyntax;
  std::vector<MD_SPANTYPE> spanStack;
} CommonMarkTextInputData;

NSAttributedString *CommonMarkTextInput(
    UIView<RCTBackedTextInputViewProtocol> *backedTextInputView);
