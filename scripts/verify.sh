#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
cd "$repo_dir"

mvn -q clean package
program_output=$(java -jar target/verify-authenticity-1.0.0.jar)
printf '%s\n' "$program_output"

printf '%s\n' "$program_output" | grep -F '源码中手工填写的创建人=李四9527' >/dev/null
printf '%s\n' "$program_output" | grep -F 'author_name=张三2026' >/dev/null
git cat-file -p HEAD | grep -F 'author 张三2026 <zhangsan2026@example.invalid>' >/dev/null

printf '\n验证通过：当前提交作者是“张三2026”，源码手写创建人是“李四9527”。\n'

