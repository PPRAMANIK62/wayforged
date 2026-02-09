#!/usr/bin/env bash
# Phase 12: Programming Languages
# Installs Rust, Go, C/C++ toolchain, Python pip, protobuf, Go tools (FULL mode only)

if [ "${WAYFORGED_MODE:-minimal}" != "full" ]; then
  echo ">>> Skipping languages (minimal mode)"
  exit 0
fi

echo ">>> Installing programming languages..."

echo ">>> Installing Rust via rustup"
if ! command_exists rustc; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

echo ">>> Installing Go"
if ! command_exists go; then
  GO_VERSION="1.25.0"
  curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf /tmp/go.tar.gz
  rm -f /tmp/go.tar.gz
  export PATH=$PATH:/usr/local/go/bin
fi

echo ">>> Installing C/C++ toolchain"
dnf_install gcc gcc-c++ clang cmake make

echo ">>> Installing Python pip"
dnf_install python3-pip

echo ">>> Installing Protocol Buffers"
dnf_install protobuf-compiler

echo ">>> Installing Go tools"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install golang.org/x/tools/cmd/goimports@latest

echo ">>> Programming languages setup complete"
