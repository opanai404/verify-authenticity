#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
cd "$repo_dir"

mvn -q clean package
program_output=$(java -jar target/verify-authenticity-1.0.0.jar)
printf '%s\n' "$program_output"

printf '%s\n' "$program_output" | grep -F '演示操作轮次=6' >/dev/null
printf '%s\n' "$program_output" | grep -F '源码中手工填写的创建人=张三2026' >/dev/null
printf '%s\n' "$program_output" | grep -F 'author_name=李四9527' >/dev/null
git cat-file -p HEAD | grep -F 'author 李四9527 <lisi9527@example.invalid>' >/dev/null

verify_round() {
    commit_ref=$1
    expected_author=$2
    expected_email=$3
    expected_creator=$4

    git cat-file -p "$commit_ref" \
        | grep -F "author $expected_author <$expected_email>" >/dev/null
    git show "$commit_ref":src/main/java/com/example/verify/AuthenticityDemo.java \
        | grep -F "创建人：$expected_creator" >/dev/null
}

verify_round 416966f '张三2026' 'zhangsan2026@example.invalid' '李四9527'
verify_round c3374b0 '李四9527' 'lisi9527@example.invalid' '张三2026'
verify_round d9aea36 '张三2026' 'zhangsan2026@example.invalid' '李四9527'
verify_round 7a70ecf '李四9527' 'lisi9527@example.invalid' '张三2026'
verify_round cb1769e '张三2026' 'zhangsan2026@example.invalid' '李四9527'
verify_round aa002fb '李四9527' 'lisi9527@example.invalid' '张三2026'

printf '\n验证通过：\n'
printf '六轮提交的 Git 作者和源码创建人交替关系全部与证据表一致。\n'
