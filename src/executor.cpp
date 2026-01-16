#include "executor.hpp"

#include <algorithm>
#include <cerrno>
#include <csignal>
#include <cstring>
#include <stdexcept>
#include <thread>

namespace vdp_utils {
namespace node_executor {

bool Executor::will_terminate_;

Executor::Executor(std::initializer_list<decltype(nodes_)::value_type> il)
    : nodes_{il} {
  will_terminate_ = false;

  struct sigaction sa;
  memset(&sa, 0, sizeof(sa));
  sa.sa_sigaction = [](int, siginfo_t*, void*) {
    Executor::will_terminate_ = true;
  };
  if (sigaction(SIGTERM, &sa, nullptr) != 0) {
    throw std::runtime_error("sigaction(TERM) failed");
  }
  if (sigaction(SIGINT, &sa, nullptr) != 0) {
    throw std::runtime_error("sigaction(INT) failed");
  }
}

void Executor::Execute(const std::chrono::milliseconds& interval) {
  std::for_each(nodes_.begin(), nodes_.end(),
                [](auto& x) { x->OnInitializing(); });

  std::for_each(nodes_.begin(), nodes_.end(), [](auto& x) { x->OnStarting(); });

  while (!will_terminate_) {
    const auto begin = std::chrono::system_clock::now();
    std::for_each(nodes_.begin(), nodes_.end(), [](auto& x) { x->RunOnce(); });
    const auto end = std::chrono::system_clock::now();
    const auto rest = interval - (end - begin);
    std::this_thread::sleep_for(rest);
  }

  std::for_each(nodes_.begin(), nodes_.end(),
                [](auto& x) { x->OnTerminating(); });
}

}  // namespace node_executor
}  // namespace vdp_utils
