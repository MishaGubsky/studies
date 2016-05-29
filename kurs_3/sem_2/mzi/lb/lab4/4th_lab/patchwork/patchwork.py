from PIL import Image
from argparse import ArgumentParser
from random import seed, randint


ITERATIONS_COUNT = 100000
INCREMENT_BY = 3
SECRET_KEY = "Leshka-povaryoshka"


def brightness(arg):
    r, g, b = arg
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def get_statistics(image, key):
    seed(key)
    pixels = image.load()
    height, width = image.size
    statistics = 0
    for i in range(ITERATIONS_COUNT):
        a = randint(0, height - 1), randint(0, width - 1)
        b = randint(0, height - 1), randint(0, width - 1)
        statistics += brightness(pixels[a]) - brightness(pixels[b])
    return statistics


def set_watermark(image, key):
    seed(key)
    pixels = image.load()
    height, width = image.size
    for i in range(ITERATIONS_COUNT):
        a = randint(0, height - 1), randint(0, width - 1)
        b = randint(0, height - 1), randint(0, width - 1)
        pixels[a] = tuple([c + INCREMENT_BY for c in pixels[a]])
        pixels[b] = tuple([c - INCREMENT_BY for c in pixels[b]])
    image.save("../media/image_patchwork.png")


def main():
    parser = ArgumentParser()
    parser.add_argument("secret_key")
    parser.add_argument("--set", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    if args.set:
        image = Image.open("../media/image.png")
        set_watermark(image, args.secret_key)

    if args.check:
        image = Image.open("../media/image_patchwork.png")
        statistics = get_statistics(image, args.secret_key)
        if abs(statistics) < ITERATIONS_COUNT * INCREMENT_BY:
            print("Image is fake")
        else:
            print("Image is original")

if __name__ == '__main__':
    main()