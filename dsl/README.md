# The Bach DSL

This is the Bach DSL project written in scala.

# Developerment

You can setup the development environment with docker. The following command can build a image from the Dockerfile in the root directory.

```sh
docker build -t bach \
  --build -arg SSH_PRV_KEY ="$(cat ~/. ssh/id_rsa)" \
  --build -arg SSH_PUB_KEY ="$(cat ~/. ssh/id_rsa.pub)" \
  --build -arg GIT_USER_EMAIL ="foo@domain" \
  --build -arg GIT_USER_NAME ="foo" \
  --build -arg GIT_REPO ="git@github.com:foo/Bach.git" \
  .
```

You can start a container from the image with the following command.

```sh
docker run -t -i --privileged bach 
```
