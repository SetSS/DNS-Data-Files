## Cheatsheet of commands


### Genereate both keys
```shell
minisign -G -p eu-fast-resolvers_public_key.pub -s eu-fast-resolvers_private_key.key
```

### Signing file

```shell
minisign -S -s eu-fast-resolvers_private_key.key -m dns-crypt2-eu-fast-resolvers.md -c "signature from minisign secret key"
```

### Check signed file

```shell
minisign -Vm dns-crypt2-eu-fast-resolvers.md -p eu-fast-resolvers_public_key.pub
```

### Get public key
```shell
awk 'NR==2' eu-fast-resolvers_public_key.pub
```