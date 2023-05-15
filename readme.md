# Abstract
- パワーシェルでSSL証明書を発行するスクリプト。
- ADCSの証明書テンプレートを使用する。

## CSR Issuance in Windows
```
certreq -new -f CSR_Base.inf CSR.req
```