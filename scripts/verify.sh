#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
cd "$repo_dir"

mvn -q clean package
program_output=$(java -jar target/verify-authenticity-1.0.0.jar)
printf '%s\n' "$program_output"

printf '%s\n' "$program_output" | grep -F '演示操作轮次=5' >/dev/null
printf '%s\n' "$program_output" | grep -F '源码中手工填写的创建人=李四9527' >/dev/null
printf '%s\n' "$program_output" | grep -F 'author_name=张三2026' >/dev/null
git cat-file -p HEAD | grep -F 'author 张三2026 <zhangsan2026@example.invalid>' >/dev/null

root_commit=$(git rev-list --max-parents=0 HEAD)
git cat-file -p "$root_commit" | grep -F 'author 张三2026 <zhangsan2026@example.invalid>' >/dev/null
git show "$root_commit":src/main/java/com/example/verify/AuthenticityDemo.java \
    | grep -F '创建人：李四9527' >/dev/null

printf '\n验证通过：\n'
printf '1. 根提交作者是“张三2026”，当时源码创建人是“李四9527”；\n'
printf '2. 当前第 5 轮提交作者是“张三2026”，当前源码创建人是“李四9527”。\n'
