package com.example.verify;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

/**
 * Git 姓名字段可编辑性演示。
 *
 * <p>创建人：张三2026</p>
 *
 * <p>上面的“创建人”只是源码中的普通文字，可由任何有文件编辑权限的人修改，
 * 它不是 Git 或 GitHub 自动验证的身份信息。</p>
 */
public final class AuthenticityDemo {

    private static final int DEMO_ROUND = 4;
    private static final String SOURCE_CREATED_BY = "张三2026";

    private AuthenticityDemo() {
    }

    public static void main(String[] args) throws IOException, InterruptedException {
        System.out.println("=== Git / GitHub 姓名字段可编辑性验证 ===");
        System.out.println("演示操作轮次=" + DEMO_ROUND);
        System.out.println("源码中手工填写的创建人=" + SOURCE_CREATED_BY);
        System.out.println();
        System.out.println("当前提交对象中保存的身份字段：");
        System.out.println(readCurrentCommit());
        System.out.println();
        System.out.println("观察：源码创建人字段与 Git 提交作者可以是不同姓名。");
        System.out.println("结论边界：这说明姓名文字可由提交端填写，不能仅凭截图中的姓名唯一确认真实操作者。");
    }

    private static String readCurrentCommit() throws IOException, InterruptedException {
        Process process = new ProcessBuilder(
                "git",
                "show",
                "-s",
                "--format=commit=%H%nauthor_name=%an%nauthor_email=%ae%ncommitter_name=%cn%ncommitter_email=%ce%nsignature_state=%G?",
                "HEAD")
                .redirectErrorStream(true)
                .start();

        String output = new String(process.getInputStream().readAllBytes(), StandardCharsets.UTF_8).strip();
        int exitCode = process.waitFor();
        if (exitCode != 0) {
            throw new IllegalStateException("无法读取 Git 提交对象，退出码=" + exitCode + "，输出=" + output);
        }
        return output;
    }
}
