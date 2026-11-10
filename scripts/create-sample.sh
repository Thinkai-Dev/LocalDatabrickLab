#!/usr/bin/env bash
set -euo pipefail
export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=us-east-1 AWS_EC2_METADATA_DISABLED=true
mkdir -p data/raw
cat > data/raw/orders.csv <<'CSV'
order_id,customer_id,product_id,quantity,unit_price,order_date
1001,C001,P101,2,19.99,2026-11-01
1002,C002,P102,1,49.50,2026-11-01
1003,C001,P102,3,49.50,2026-11-02
CSV
aws --endpoint-url=http://localhost:4566 s3 cp data/raw/orders.csv s3://retail-lab-raw/orders/orders.csv
aws --endpoint-url=http://localhost:4566 s3 ls s3://retail-lab-raw/orders/
