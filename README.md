
# 项目会在北京时间 8:30 检查更新，如有更新会自动编译
https://github.com/JohnsonRan/packages_builder/releases
## Speedtest-EX
https://github.com/JohnsonRan/packages_net_speedtest-ex
- 配置文件位于 `/etc/speedtest-ex/config.toml`
- 修改配置后执行 `/etc/init.d/speedtest-ex restart` 重启服务
- 默认运行在 `8989` 端口
- 若不再需要直接前往软件包处删除 `speedtest-ex` 即可

## Node exporter
https://github.com/JohnsonRan/packages_utils_node_exporter
- 需配合 Grafana + Prometheus 使用
- 端口为默认 `9100`
- 若不再需要直接前往软件包处删除 `node_exporter` 即可

## boltbrowser
https://github.com/JohnsonRan/packages_utils_boltbrowser
- 可视化查看 mihomo 的 `cache.db`
```
boltbrowser /etc/mihomo/run/cache.db
```
- 若不再需要直接前往软件包处删除 `boltbrowser` 即可

## neko-status
https://github.com/JohnsonRan/packages_utils_neko-status  
https://github.com/fev125/dstatus
- 探针被控端
- 配置文件位于 `/etc/neko-status/config.yaml`
- 若不再需要直接前往软件包处删除 `neko-status` 即可

## v2ray-geodata
替换为 https://github.com/MetaCubeX/meta-rules-dat