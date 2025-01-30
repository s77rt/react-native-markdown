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
  Attribute attribute;
  bool open;
  unsigned position;

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

    htmlTags.push_back(
        (HTMLTag){attribute.attribute, true, attribute.location});
    htmlTags.push_back((HTMLTag){attribute.attribute, false,
                                 attribute.location + attribute.length});
  }
  std::sort(htmlTags.begin(), htmlTags.end());

  /**
   * - (*6) Chars can be encoded into 6 chars each (&<>"' only) (worst case)
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

    if (htmlTag.open) {
      wcscat_short(output, L"<md-div>");
    } else {
      wcscat_short(output, L"</md-div>");
    }

    cursor = htmlTag.position;
  }
  wcsncat_html_encode_short(output, input + cursor, inputSize - cursor);
  wcscat_short(output, L"</md-div>");

  return output;
}
