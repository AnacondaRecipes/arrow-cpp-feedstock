// Build a small Arrow array with the installed library and check its contents.
#include <arrow/api.h>
#include <arrow/util/config.h>

#include <iostream>
#include <memory>

int main() {
  arrow::Int64Builder builder;
  if (!builder.AppendValues({1, 2, 3}).ok()) {
    std::cerr << "AppendValues failed" << std::endl;
    return 1;
  }
  std::shared_ptr<arrow::Array> array;
  if (!builder.Finish(&array).ok()) {
    std::cerr << "Finish failed" << std::endl;
    return 1;
  }
  auto values = std::static_pointer_cast<arrow::Int64Array>(array);
  if (values->length() != 3 || values->Value(0) != 1 || values->Value(2) != 3) {
    std::cerr << "unexpected array contents: " << array->ToString() << std::endl;
    return 1;
  }
  std::cout << "arrow " << arrow::GetBuildInfo().version_string << " smoke test passed" << std::endl;
  return 0;
}
