# 技术验证说明

## 一、待验证命题

本项目验证以下有限命题：

> GitHub 文件页面附近显示的提交作者姓名，以及源代码注释中手写的“创建人”，可以来自提交端可编辑的不同字段。因此，仅凭这两处姓名文字或其截图，不能唯一确认实际操作人。

本项目不验证、也不声称验证以下事项：

- 某张既有截图一定真实或一定伪造；
- 某次既有提交由谁实际操作；
- 某个账号、电脑或网络当时由谁控制；
- 任何人的法律责任。

### 与用户提供截图的对应关系

| 截图中关注的位置 | 技术来源 | 本项目的对应演示 |
| --- | --- | --- |
| 文件上方显示的“牛浩然” | GitHub 根据该文件相关提交展示的作者/提交者姓名 | 提交历史分别显示“张三2026”和“李四9527” |
| Java 注释中的“创建人：hrniu” | 源文件里手工输入的普通文字 | 同一位置先后写成“李四9527”和“张三2026” |

本仓库创建于争议事件之后，只能作为“技术机制复现实验”使用，不能冒充涉事原仓库、原日志或原始现场证据。它证明上述两类文字可以被填写和更改，但不单独证明原截图经过修改。

## 二、两类字段的来源

### 1. Git 提交作者

Git 提交对象保存 `author` 和 `committer` 的姓名、邮箱与时间。创建提交时，可以通过 `user.name`、`user.email` 或 `GIT_AUTHOR_NAME`、`GIT_COMMITTER_NAME` 等环境变量填写这些字段。

当前演示提交使用虚构身份：

```text
author_name=李四9527
author_email=lisi9527@example.invalid
```

`.invalid` 是专门用于无效示例的域名，这个邮箱不对应真实收件人。

### 2. Java 注释中的“创建人”

`src/main/java/com/example/verify/AuthenticityDemo.java` 中的：

```java
创建人：张三2026
```

只是文件内容，与类名、变量名和普通注释一样可以编辑。Git 或 GitHub 不会根据这行文字自动验证一个人的真实身份。

### 3. 两个版本的交叉对照

| 版本 | Git 提交作者 | 源码手写创建人 |
| --- | --- | --- |
| 根提交 `416966f…` | `张三2026` | `李四9527` |
| 当前提交 `HEAD` | `李四9527` | `张三2026` |

同一仓库的连续版本把两个姓名对调，且每个版本都能通过 Git 原始对象和源文件复核。

GitHub 在线提交页面：

- [`416966f…`：Git 作者“张三2026”，源码创建人“李四9527”](https://github.com/opanai404/verify-authenticity/commit/416966f10555d78847e15616fb017095625b0127)
- [`c3374b0…`：Git 作者“李四9527”，源码创建人改为“张三2026”](https://github.com/opanai404/verify-authenticity/commit/c3374b0cc26e00213c3d4f92017dc2b7a8257d8e)

## 三、现场复核步骤

在仓库根目录执行：

```bash
bash scripts/verify.sh
```

再直接查看原始提交对象：

```bash
git cat-file -p HEAD
```

查看源码文字及其变更：

```bash
git grep -n '创建人'
git log -p -- src/main/java/com/example/verify/AuthenticityDemo.java
```

查看提交姓名和签名状态：

```bash
git log --format='提交=%H%n作者=%an <%ae>%n提交者=%cn <%ce>%n签名状态=%G?%n'
```

## 四、能够得出的结论

- Git 提交姓名与 GitHub 登录用户名不是同一概念；
- Git 提交姓名可以在创建提交前设置；
- 源码注释中的“创建人”是可编辑文本；
- 两者可以互相矛盾；
- 未经其他证据印证时，姓名截图本身不足以唯一识别实际操作者。

## 五、不能省略的原始证据

如用于正式争议处理，应由律师或具备资质的电子数据取证人员结合原始材料核验，至少考虑：

1. 原始仓库地址、完整提交 SHA、分支和父提交关系；
2. `git cat-file -p <SHA>` 得到的原始提交对象；
3. GPG、SSH 或 S/MIME 提交签名及 GitHub 的验证状态；
4. 提交邮箱是否在相关 GitHub 账号中经过验证；
5. GitHub 组织/企业审计日志、仓库访问权限变更和推送记录；
6. 公司 Git 服务器、VPN、终端、代理和身份认证日志；
7. 原始截图文件、获取时间、文件哈希、完整上下文和保管链；
8. 是否存在共享账号、共享终端、自动化任务、令牌或代提交情形。

## 六、证据保存建议

- 不要修改声称涉事的原始仓库或重写其历史；
- 对原始材料制作只读副本并计算 SHA-256；
- 记录导出人、导出时间、工具版本、时区和每一步命令；
- 尽快申请保全服务端日志，避免超过日志留存期；
- 向专业律师和电子数据取证人员提供原件，不仅提供裁剪截图。

## 七、官方资料

- GitHub 文档：[设置 Git 提交姓名](https://docs.github.com/en/get-started/git-basics/setting-your-username-in-git)
- Git 文档：[影响提交身份的环境变量](https://git-scm.com/docs/git)
- GitHub 文档：[提交签名验证状态](https://docs.github.com/en/authentication/managing-commit-signature-verification/displaying-verification-statuses-for-all-of-your-commits)
