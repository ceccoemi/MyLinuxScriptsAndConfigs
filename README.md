# Shell scripts

All the scripts are POSIX compliant.

## up

Works only on Debian-based distributions.

Simple shell script that keeps up-to-date the system and removes some unnecessary packages. It performs an update of the APT packages and the snaps packages, which I use many of them. If you still don't know what the snaps are please take a look at [their site](https://snapcraft.io/).

## flipscreen

Shell script used to flip the screen of 180 degrees and show the virtual keyboard onboard (if it's installed in the system). It's very useful for 2-1 laptops with touchscreen. In Microsoft Windows 10 those operations are performed automatically when the laptop's screen is flipped over 180 degrees, this script tries to bring that feature to Linux.

If the screen has a normal orientation the execution of this script will flip the screen upside down, if the script it's executed again with a rotated screen it will restore the original orientation.

## clitesseract

This is a very simple shell script that let you execute the `tesseract` command without worry of the output file. [Tesseract](https://github.com/tesseract-ocr/tesseract) is software to perform OCR.

With the classic `tesseract` command you have to execute

    tesseract imagename outputfile

Then you have to read the content of `outputfile` to see the results of the execution. Maybe you are not interested to keep that file, so after you have read it you have to delete it.

`clitesseract` does these operations for you. When you execute `clitesseract` don't specify the output file, simply run:

    clitesseract imagename

and then the output of the execution of Tesseract on `imagename` will be printed directly on the terminal.

`clitesseract` is fully compatible with all the other Tesseract parameter, for example:

    clitesseract imagename --psm 7 -c tessedit_char_whitelist=abc tsv

it will be displayed the output of the `.tsv` file with PageSegmentationMode number 7 and whitelist=abc.

## set-hyper-threading

Script to enable or disable the hyper-threading technology if it's supported by the system.

To disable hyper-threading run:

    $ sudo set-hyper-threading 0

To enable hyper-threading run:

    $ sudo set-hyper-threading 1
