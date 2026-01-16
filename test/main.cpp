#include <iostream>
#include <stdexcept>

#include <vdp-utils/executor.hpp>

class SampleNode : public vdp_utils::node_executor::Node {
 public:
  explicit SampleNode() {}

  void OnStarting() override { std::cout << "OnStarting()" << std::endl; }

  void RunOnce() override { std::cout << "RunOnce()" << std::endl; }

  void OnTerminating() override { std::cout << "OnTerminating()" << std::endl; }

 private:
};

int main(int argc, char* argv[]) {
  int exit_code = 0;

  try {
    auto node = std::make_shared<SampleNode>();
    vdp_utils::node_executor::Executor executor{{node}};
    executor.Execute(std::chrono::milliseconds(1000));
  } catch (const std::exception& e) {
    std::cout << e.what() << std::endl;
    exit_code = 1;
  }
  return exit_code;
}
