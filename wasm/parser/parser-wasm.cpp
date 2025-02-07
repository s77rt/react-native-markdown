#include "parser.h"

wchar_t *wcscat_short(wchar_t *s1, const wchar_t *s2) {
  wchar_t *p;
  wchar_t *q;
  const wchar_t *r;

  p = s1;
  while (*p)
    p++;
  q = p;
  r = s2;
  while (*r)
    *q++ = *r++;
  *q = '\0';
  return s1;
}

wchar_t *wcsncat_html_encode_short(wchar_t *s1, const wchar_t *s2, size_t n) {
  wchar_t *p;
  wchar_t *q;
  const wchar_t *r;

  p = s1;
  while (*p)
    p++;
  q = p;
  r = s2;
  while (*r && n) {
    switch (*r) {
    case L'&': {
      *q++ = L'&';
      *q++ = L'a';
      *q++ = L'm';
      *q++ = L'p';
      *q++ = L';';
      r++;
      break;
    }
    case L'<': {
      *q++ = L'&';
      *q++ = L'l';
      *q++ = L't';
      *q++ = L';';
      r++;
      break;
    }
    case L'>': {
      *q++ = L'&';
      *q++ = L'g';
      *q++ = L't';
      *q++ = L';';
      r++;
      break;
    }
    case L'\"': {
      *q++ = L'&';
      *q++ = L'q';
      *q++ = L'u';
      *q++ = L'o';
      *q++ = L't';
      *q++ = L';';
      r++;
      break;
    }
    case L'\'': {
      *q++ = L'&';
      *q++ = L'#';
      *q++ = L'x';
      *q++ = L'2';
      *q++ = L'7';
      *q++ = L';';
      r++;
      break;
    }
    case L'\n': {
      *q++ = L'<';
      *q++ = L'b';
      *q++ = L'r';
      *q++ = L'>';
      r++;
      break;
    }
    default:
      *q++ = *r++;
      break;
    }
    n--;
  }
  *q = '\0';
  return s1;
}

typedef struct HTMLTag {
  unsigned position;
  const wchar_t *tag;

  bool operator<(const HTMLTag &htmlTag) const {
    return (position < htmlTag.position);
  }
} HTMLTag;

wchar_t *parse_and_format(const wchar_t *input,
                          unsigned inputSize) asm("PARSEANDFORMAT");
wchar_t *parse_and_format(const wchar_t *input, unsigned inputSize) {
  std::vector<AttributeFeature> attributes = parse(input, inputSize);

  std::vector<HTMLTag> htmlTags;
  for (const AttributeFeature &attribute : attributes) {
    if (attribute.length == 0) {
      continue;
    }
    if (attribute.attribute == Attribute_Unknown) {
      continue;
    }

    const wchar_t *openTag;
    const wchar_t *closeTag;
    switch (attribute.attribute) {
    case Attribute_Heading: {
      switch (attribute.data1) {
      case 1:
        openTag = L"<md-h1>";
        closeTag = L"</md-h1>";
        break;
      case 2:
        openTag = L"<md-h2>";
        closeTag = L"</md-h2>";
        break;
      case 3:
        openTag = L"<md-h3>";
        closeTag = L"</md-h3>";
        break;
      case 4:
        openTag = L"<md-h4>";
        closeTag = L"</md-h4>";
        break;
      case 5:
        openTag = L"<md-h5>";
        closeTag = L"</md-h5>";
        break;
      case 6:
        openTag = L"<md-h6>";
        closeTag = L"</md-h6>";
        break;
      default:
        openTag = L"";
        closeTag = L"";
        break;
      };
      break;
    }
    case Attribute_Blockquote:
      openTag = L"<md-blockquote>";
      closeTag = L"</md-blockquote>";
      break;
    case Attribute_Codeblock:
      openTag = L"<md-pre>";
      closeTag = L"</md-pre>";
      break;
    case Attribute_HorizontalRule:
      openTag = L"<md-hr>";
      closeTag = L"</md-hr>";
      break;
    case Attribute_Bold:
      openTag = L"<md-b>";
      closeTag = L"</md-b>";
      break;
    case Attribute_Italic:
      openTag = L"<md-i>";
      closeTag = L"</md-i>";
      break;
    case Attribute_Link:
      openTag = L"<md-a>";
      closeTag = L"</md-a>";
      break;
    case Attribute_Image:
      openTag = L"<md-img>";
      closeTag = L"</md-img>";
      break;
    case Attribute_Code:
      openTag = L"<md-code>";
      closeTag = L"</md-code>";
      break;
    case Attribute_Strikethrough:
      openTag = L"<md-s>";
      closeTag = L"</md-s>";
      break;
    case Attribute_Underline:
      openTag = L"<md-u>";
      closeTag = L"</md-u>";
      break;
    default:
      openTag = L"";
      closeTag = L"";
    };

    htmlTags.push_back((HTMLTag){attribute.location, openTag});
    htmlTags.push_back(
        (HTMLTag){attribute.location + attribute.length, closeTag});
  }
  std::sort(htmlTags.begin(), htmlTags.end());

  /**
   * - (*6) Chars can be encoded into 6 chars each (&<>"'\n) (worst case)
   * - (+2) Wrapping tags - (32) Tag max length (overestimated)
   * - (+1) Null terminating character
   */
  unsigned outputSize = (inputSize * 6) + ((htmlTags.size() + 2) * 32) + 1;
  wchar_t *output = (wchar_t *)malloc(outputSize * sizeof(wchar_t));
  output[0] = '\0';

  unsigned cursor = 0;
  wcscat_short(output, L"<md-div>");

  for (const HTMLTag &htmlTag : htmlTags) {
    wcsncat_html_encode_short(output, input + cursor,
                              htmlTag.position - cursor);
    wcscat_short(output, htmlTag.tag);
    cursor = htmlTag.position;
  }

  wcsncat_html_encode_short(output, input + cursor, inputSize - cursor);
  wcscat_short(output, L"</md-div>");

  return output;
}
