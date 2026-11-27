#!/usr/bin/env python3
"""M1: SessionStart 确定性工作区与测试运行器事实探测（零二模型、零泄露、~45 tokens、Python 3.6+ 兼容）。
仅检查当前工作目录（cwd）的公开顶层目录名、Python 版本与标准测试入口，
绝不输出绝对宿主路径、容器环境变量或任何评测元数据。"""
import json
import os
import shutil
import sys
from pathlib import Path


def detect_test_runner(cwd):
    py = shutil.which("python") or shutil.which("python3")
    has_pytest = bool(shutil.which("pytest"))
    if (cwd / "tests" / "runtests.py").is_file():
        return "Test runner: `cd tests && python runtests.py <app_or_test_label>` (run without `-I`; targeted label only, not full suite)."
    if (cwd / "bin" / "test").is_file():
        if has_pytest:
            return "Test runner: `python bin/test <path_to_test_file>` or `pytest -q <test_file>` (targeted test only, not full suite)."
        return "Test runner: `python bin/test <path_to_test_file>` (targeted test only; `pytest` is not installed)."
    if has_pytest and any(
        (cwd / f).exists()
        for f in ("pytest.ini", "pyproject.toml", "setup.cfg", "tox.ini", "conftest.py", "setup.py", "tests", "testing")
    ):
        return "Test runner: `pytest -q <test_file>::<test_name>` (run targeted test only, not bare full-suite `pytest`)."
    if (cwd / "package.json").is_file():
        try:
            pkg = json.loads((cwd / "package.json").read_text(errors="replace"))
            tcmd = (pkg.get("scripts") or {}).get("test")
            if tcmd:
                return "Test script in package.json: `%s` (run targeted test)." % str(tcmd)[:80]
        except Exception:
            pass
    if (cwd / "Cargo.toml").is_file():
        return "Test runner: `cargo test <filter>` (targeted)."
    if (cwd / "go.mod").is_file():
        return "Test runner: `go test ./<pkg> -run <Pattern>`."
    if has_pytest:
        return "Test runner: `pytest -q <test_file>` (targeted)."
    if py:
        return "Test runner: `python -m unittest <module>` (targeted)."
    return ""


def detect_workspace_snapshot(cwd):
    parts = []
    py_ver = "%d.%d.%d" % sys.version_info[:3]
    parts.append("Python %s" % py_ver)
    try:
        entries = []
        for p in sorted(cwd.iterdir(), key=lambda x: (not x.is_dir(), x.name)):
            if p.name.startswith("."):
                continue
            entries.append(p.name + ("/" if p.is_dir() else ""))
            if len(entries) >= 12:
                break
        if entries:
            parts.append("Top-level: " + ", ".join(entries))
    except Exception:
        pass
    return "Workspace: " + " | ".join(parts) + "."


def detect_env_facts(cwd):
    facts = []
    runner = detect_test_runner(cwd)
    if runner:
        facts.append(runner)
    snap = detect_workspace_snapshot(cwd)
    if snap:
        facts.append(snap)
    return " ".join(facts)


def main():
    raw = sys.stdin.read()
    ev = {}
    if raw.strip():
        try:
            ev = json.loads(raw)
        except ValueError:
            ev = {}
    cwd = Path(ev.get("cwd") or os.getcwd())
    msg = detect_env_facts(cwd)
    if not msg:
        return
    out = {
        "hookSpecificOutput": {
            "hookEventName": "SessionStart",
            "additionalContext": msg,
        }
    }
    sys.stdout.write(json.dumps(out))


if __name__ == "__main__":
    main()
