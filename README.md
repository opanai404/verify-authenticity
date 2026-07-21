# Git / GitHub 姓名字段可编辑性验证（Java）

这是一个故意保持简单的 Java 21 演示项目，用可重复实验说明 GitHub 文件页面上两类姓名文字的来源不同：

1. 文件上方的提交作者来自 Git 提交对象中的 `author` / `committer` 字段；
2. Java 注释里的“创建人”只是源码中的普通文字；
3. 两类文字都可以在提交发生前由本地用户填写，单独出现时都不足以唯一证明真实操作者。

> 本仓库只验证技术机制，不判断任何特定截图真假，也不认定任何具体人员实施了某项操作。

## 可复现实验

两个连续提交故意使用相反的姓名组合：

| 版本 | Git 提交作者 | Java 源码“创建人” |
| --- | --- | --- |
| 根提交 `416966f…` | `张三2026` | `李四9527` |
| 当前提交 `HEAD` | `李四9527` | `张三2026` |

前后两个版本将姓名对调，直接证明两个位置并不互相校验。Git 提交作者来自创建提交时的身份字段；源码“创建人”来自 `AuthenticityDemo.java` 中可编辑的普通文字。

可直接在线查看两次提交：[`416966f…`（张三2026）](https://github.com/opanai404/verify-authenticity/commit/416966f10555d78847e15616fb017095625b0127)和 [`c3374b0…`（李四9527）](https://github.com/opanai404/verify-authenticity/commit/c3374b0cc26e00213c3d4f92017dc2b7a8257d8e)。

这两个姓名都是虚构的演示名称，邮箱使用保留的 `.invalid` 域名，不冒充真实账号。

## 一键运行

要求：JDK 21、Maven、Git。

```bash
bash scripts/verify.sh
```

也可以逐步执行：

```bash
mvn clean package
java -jar target/verify-authenticity-1.0.0.jar
git cat-file -p HEAD
git log -p -- src/main/java/com/example/verify/AuthenticityDemo.java
```

`git cat-file -p HEAD` 直接读取 Git 提交对象，其中能看到 `author` 和 `committer` 原始字段；Java 程序同时打印源码中手写的“创建人”。

## 给非技术人员的简要结论

截图中出现一个姓名，只能证明截图在那个位置显示了这段文字。若要进一步判断真实操作者，至少还应核对原始仓库、完整提交 SHA、提交对象、签名状态、账号邮箱关联、组织审计日志、服务器访问记录及证据保全过程。详见 [EVIDENCE.md](EVIDENCE.md)。

## 官方依据

- [GitHub：Git 提交姓名不等于 GitHub 用户名，且可以使用任意文字](https://docs.github.com/en/get-started/git-basics/setting-your-username-in-git)
- [Git：`GIT_AUTHOR_NAME`、`GIT_COMMITTER_NAME` 可覆盖配置](https://git-scm.com/docs/git)
- [GitHub：签名验证状态用于提高对提交身份的可信度](https://docs.github.com/en/authentication/managing-commit-signature-verification/displaying-verification-statuses-for-all-of-your-commits)
