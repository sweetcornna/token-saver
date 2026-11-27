# Experimental variants (not installed by the marketplace)

These are the ablation arms from the Kimi K3.1 Pro (`xhigh`) runs, kept for reference. The marketplace still installs only `plugin/` (0.2.0). None of these variants has passed a quality non-inferiority check, so none replaces the released style.

| Arm | Contents |
|---|---|
| `F2bOnly` | Only the closing habit: finish once the change is made and the relevant tests or reproduction pass. |
| `K_synth_m1` | Targeted search and sliced reads, no git-history archaeology, check sibling code paths, targeted tests only; plus the M1 hook. |
| `K_v2` | 0.2.0's batching habits combined with the K_synth focus rules (no `/tmp/repro.py` mention). |
| `K_v2_m1` | `K_v2` plus the M1 hook. |
| `K_lean_m1` | A three-line compression of `K_v2`, plus the M1 hook. |

**M1 hook** (`hooks/m1_env_probe.py`): a `SessionStart` hook that prints about 45 tokens of workspace facts: the Python version, top-level entries, and the repository's targeted test command (for example Django's `tests/runtests.py`). It makes no model calls and does not read anything outside the working directory. In the Kimi runs it reduced the number of tasks that hit test-runner errors in all three pairs (16→5, 19→9, 20→7), but its effect on cost was not established.

To try one for a single session: `claude --plugin-dir experiments/kimi-k3.1-pro/K_v2_m1`.

---

这里是 Kimi K3.1 Pro（`xhigh`）消融用过的实验臂，只作参考。marketplace 仍然只安装 `plugin/`（0.2.0）。这些变体都没有通过质量非劣效检验，所以都不替换已发布版本。
