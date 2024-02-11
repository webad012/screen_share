# SCREEN SHARE
* screen share example in pure js
* communication in websocket (php ratchet)

## build and run
### build
```
bash run.sh -b
```
### run
```
bash run.sh -r
```
### stop
```
bash run.sh -s
```
### restart
```
bash run.sh -s && bash run.sh -b && bash run.sh -r
```

## Implementation details
* screen capture implemented using [MediaDevices: getDisplayMedia() method](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getDisplayMedia)
* needs HTTPS/SSL to work
* to work in non-SSL enviroment (local dev) add your ip to
    * chrome: chrome://flags/#unsafely-treat-insecure-origin-as-secure
    * brave: brave://flags/#unsafely-treat-insecure-origin-as-secure