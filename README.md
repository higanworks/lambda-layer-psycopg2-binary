# lambda-layer-psycopg2-binary

install psycopg2-binary

## requirements

- docker (or compatible runtime)
- AWS-CLI
- GNU Make

## Deploy

```
$ AWS_PROFILE=`YOUR_PROFILE` make -e push

#=> "arn:aws:lambda:${REGION}:${YOUR_AWS_ACCOUNT_ID}:layer:psycopg2-binary-3-11-arm64:1"
```



### option (envs)

```
export AWS_PROFILE=...
export AWS_REGION=...
export ARCHITECTURE=[amd64|arm64]
```

check Makefile.

