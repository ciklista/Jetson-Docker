# Jetson-Docker

(L4T based)[https://ngc.nvidia.com/catalog/containers/nvidia:l4t-base] Docker container for NVIDIA Jetson devices. 
Including TensorFlow (python) and GStreamer Support for OpenCV (required when running gstreamer commands through the opencv api, e.g. with the `cv2` python package).

To `run`  a docker container with GPU support on a Jetson, `run` your docker container with ``--runtime=nvidia`` or [change the default runtime](https://github.com/dusty-nv/jetson-containers#docker-default-runtime). If you need to access NVIDIA libraries (such as e.g. CUDNN) during ``build`` of your container you will need to change the default runtime, as the `--runtime` flag is not available for `docker build`.

```
docker build . -t jetson
docker run  -v /tmp/argus_socket:/tmp/argus_socket \
            -it jetson
```

Mouting `/tmp/argus_socket` will allow to access any cameras connected to the Jetson.

Tested on NVIDIA Jetson Xavier NX.