## 概要

このプロジェクトは、**Digdag**（ワークフローエンジン）と **Embulk**（データ転送ツール）を使用してETL（Extract, Transform, Load）パイプラインを構築・実行する学習プロジェクトです。

通信会社の顧客データ（CSV）を使用して、PostgreSQL → ビュー作成 → CSV出力 → MySQL という一連のデータフローを自動化します。
※csvデータはAIによって自動生成されたものです。

## アーキテクチャ

```
CSV データ → PostgreSQL → ビュー作成 → CSV出力 → MySQL
    ↑              ↑           ↑          ↑
  Embulk       Embulk      Embulk     Embulk
    ↑              ↑           ↑          ↑
           Digdag ワークフロー制御
```

## データフロー

1. **CSV インポート**: `telecom_customers.csv` → PostgreSQL
2. **ビュー作成**: PostgreSQL で集計ビューを作成
3. **CSV エクスポート**: ビューデータを CSV として出力
4. **MySQL インポート**: 出力した CSV を MySQL にロード

## プロジェクト構成

```
.
├── docker-compose.yml        # Docker環境定義
├── Dockerfile                # Digdag+Embulk統合イメージ
├── digdag/
│   └── data_inout.dig        # メインワークフロー定義
├── embulk/
│   ├── import_postgres_csv.yml     # CSV→PostgreSQL
│   ├── create_view_postgres.yml    # ビュー作成
│   ├── export_view_to_csv.yml      # ビュー→CSV
│   └── import_csv_to_mysql.yml     # CSV→MySQL
├── sql/
│   ├── postgres_create_view.sql    # ビュー作成SQL
│   └── mysql_import.sql           # MySQL用SQL
├── data/
│   └── telecom_customers.csv      # ソースデータ（通信会社顧客情報）
└── middle_data/                   # 中間ファイル格納
```

## データ詳細

### telecom_customers.csv
通信会社の顧客データ（約16MB、20カラム）

| カラム名 | データ型 | 説明 |
|----------|----------|------|
| customer_id | 数値 | 顧客ID |
| contract_type | 文字列 | 契約種別（個人/法人） |
| prefecture | 文字列 | 都道府県 |
| age | 数値 | 年齢 |
| gender | 文字列 | 性別 |
| plan_type | 文字列 | プラン種別 |
| monthly_fee | 数値 | 月額料金 |
| device_type | 文字列 | デバイス種別 |
| network_type | 文字列 | ネットワーク種別 |
| data_usage_gb | 小数 | データ使用量(GB) |
| churn_risk_score | 小数 | 解約リスクスコア |
| その他 | - | 契約日、支払方法、年収等 |

## 環境構築・実行

### 前提条件
- Docker Desktop
- Docker Compose

## 技術スタック

- **Digdag 0.10.5.1**: ワークフローエンジン
- **Embulk 0.10.5**: データ転送ツール
- **PostgreSQL 15**: プライマリデータベース
- **MySQL 8.0**: セカンダリデータベース
- **Java 8**: 実行環境
- **Docker**: コンテナ化

## 学習ポイント

1. **Digdagワークフロー**: 複数ステップの依存関係管理
2. **Embulk設定**: 異なるデータソース間の変換設定
3. **Docker Compose**: 複数サービスの連携
4. **ETLパイプライン**: データの抽出・変換・読み込み
5. **データベース操作**: PostgreSQL・MySQL両方の扱い