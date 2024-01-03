#! /usr/bin/env python

import argparse
import json
import os
import pathlib

import material_color_utilities_python as color_utils
import PIL


def get_material_you_colors(image_path: str, element: str) -> dict:
    """Get the material you pallete colors from an image and save them to a
    JSON file if it isn't already. Then return the path to that JSON file.

    Arguments:
        image_path: The location of the image.

    Returns:
        A dict of image accent color, button accent color and button text color eg: {'image_accent': '#292929', 'button_accent': '#BEBFC1', 'button_text': '#292929'}
    """
    defaults = {
        "image_accent": "#292929",
        "button_accent": "#BEBFC1",
        "button_text": "#292929",
    }

    if image_path == "No players found":
        return defaults[element]

    # if the color cache already exists then load that and return
    color_cached = f"{os.path.dirname(image_path)}/colors.json"
    color_cached = color_cached.replace("file://", "")
    color_cached = pathlib.PosixPath(color_cached)

    if color_cached.is_file():
        parsed_colors = json.loads(color_cached.read_text())
    else:
        image_path = image_path.replace("file://", "")
        img = PIL.Image.open(image_path)
        basewidth = 64
        wpercent = basewidth / float(img.size[0])
        hsize = int((float(img.size[1]) * float(wpercent)))
        img = img.resize((basewidth, hsize), PIL.Image.Resampling.LANCZOS)

        theme = color_utils.themeFromImage(img)
        themePalette = theme.get("palettes")
        themePalettePrimary = themePalette.get("primary")
        parsed_colors = {
            "image_accent": color_utils.hexFromArgb(themePalettePrimary.tone(40)),
            "button_accent": color_utils.hexFromArgb(themePalettePrimary.tone(90)),
            "button_text": color_utils.hexFromArgb(themePalettePrimary.tone(10)),
        }
    if "firefox-mpris" in image_path:
        return parsed_colors

    # for other players like spotify - save / cache the thumbnail and return its
    # cache path instead
    color_cached.write_text(json.dumps(parsed_colors))
    return parsed_colors[element]


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("file")
    parser.add_argument("--element", default="button_text")

    args = parser.parse_args()

    print(get_material_you_colors(args.file, args.element))
