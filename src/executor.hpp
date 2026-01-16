#ifndef VDP_UTILS_NODE_EXECUTOR_HPP_
#define VDP_UTILS_NODE_EXECUTOR_HPP_

#include <atomic>
#include <chrono>
#include <cstdint>
#include <memory>
#include <vector>

namespace vdp_utils {
namespace node_executor {

class Node {
 public:
  virtual void OnInitializing(){};
  virtual void OnStarting(){};
  virtual void RunOnce() = 0;
  virtual void OnTerminating(){};
};

class Executor final {
 private:
  std::vector<std::shared_ptr<Node>> nodes_;
  static bool will_terminate_;

 public:
  Executor(std::initializer_list<decltype(nodes_)::value_type> il);

  void Execute(const std::chrono::milliseconds& interval);
};

}  // namespace node_executor
}  // namespace vdp_utils

#endif  // VDP_UTILS_NODE_EXECUTOR_HPP_
