#import "md4c/md4c.h"
#import <React/RCTBackedTextInputViewProtocol.h>
#import <vector>

typedef struct CommonMarkTextInputData {
  std::vector<MD_SPANTYPE> spanStack;
} CommonMarkTextInputData;

void CommonMarkTextInput(
    UIView<RCTBackedTextInputViewProtocol> *backedTextInputView);
