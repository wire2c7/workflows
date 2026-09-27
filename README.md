# workflows

wire2c7 のリポジトリで共有する GitHub Actions の再利用可能ワークフローと Renovate の設定です。

## 再利用可能ワークフロー

### `nix-ci.yaml`

Nix devShell のツールでリポジトリを検査します。ローカルの devShell と同じツール・同じバージョンで CI を実行するためのものです。

利用側のリポジトリには次が必要です。

- `flake.nix` の `devShells.default` に `prek`・`betterleaks`・`commitlint` が含まれていること
- `prek` の設定（`.pre-commit-config.yaml`）と `commitlint` の設定があること

```yaml
jobs:
  ci:
    uses: wire2c7/workflows/.github/workflows/nix-ci.yaml@<commit-hash> # vX.Y.Z
```

ステータスチェックの名前は `<呼び出し側のジョブ名> / check`（上の例では `ci / check`）になります。

## Renovate の共有設定

`default.json` が共有設定です。

```json
{
  "extends": ["github>wire2c7/workflows#vX.Y.Z"]
}
```

## バージョン管理

変更は semver のタグ（`vX.Y.Z`）でリリースします。利用側は、ワークフローはタグのコミットハッシュ（コメントにタグ）で、Renovate の設定はタグで参照してください。どちらも利用側の Renovate が更新します。
