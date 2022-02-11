# docker-samba

Small and flexible docker image with Samba server

## Usage
```
docker run -d \
    -p 137:137/udp \
    -p 138:138/udp \
    -p 139:139 \
    -p 445:445 \
    -e USERS="one|1234 two|5678" \
    -e WORKGROUP=WORKGROUP \
    -e SERVER_NAME=Docker \
    -v ~/samba-home:/home/one \
    -v ~/project:/mnt/project \
    -v ~/videos:/mnt/videos:ro \
    helmuthb/samba-server
```

## Configuration

Environment variables:
- `USERS` - space and `|` separated list (optional, default: `user|password`)
  - format `name1|password1[|folder1][|uid1] name2|password2[|folder2][|uid2]`
- `WORKGROUP` - name of workgroup
- `SERVER_NAME` - name of server

## USERS examples

- `user|password foo|bar|/home/foo`
- `user|password|/home/user/dir|10000`
- `user|password||10000`
