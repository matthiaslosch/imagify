# Imagify

Turn files into images and back.

## Usage

To turn a file into (multiple) images, use

```sh
$ ./imagify.sh <--name NAME> <--format FORMAT> FILE
```

To get the file back, use

```sh
$ ./unimagify.sh <--output OUTPUT> IMAGES...
```

The images get converted in the specified order.

## Dependencies

* [ImageMagick](https://imagemagick.org) (tested with 7.1.0-33, probably works with older versions as well)
