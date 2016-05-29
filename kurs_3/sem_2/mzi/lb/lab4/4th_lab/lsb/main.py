import random

__author__ = 'Mikhail'
# -*- coding: utf-8 -*-

from PIL import Image, ImageDraw


def downloadImage(path):
	return Image.open(path)


def convert_pixelColor(pix, i, j, z, value):
	color = pix[i, j][z] & value
	return color


def generateSecretByte(message, symbol, bit):
	message_bits = message[symbol] >> bit
	message_bits &= 3
	secret_bit = 252 | message_bits
	return secret_bit


def fuseMessage(bin_message, container):
	width = container.size[0]
	height = container.size[1]
	pix = container.load()
	current_bit = 6
	current_symbol = 0
	count_symbols = len(bin_message)
	for j in range(0, height):
		for i in range(0, width):
			new_RGB = [0, 0, 0]
			for z in range(3):
				if current_bit < 0:
					current_bit = 6
					current_symbol += 1
					if current_symbol == count_symbols:
						return container

				secret_byte = generateSecretByte(bin_message, current_symbol, current_bit)
				current_bit -= 2
				new_RGB[z] = convert_pixelColor(pix, i, j, z, secret_byte)
			container.putpixel((i, j), tuple(new_RGB))


def convert(count, container):
	width = container.size[0]
	height = container.size[1]
	pix = container.load()
	count_symbols = count
	current_bit = 6
	current_symbol = 0
	message = ''
	symbol = 0
	for j in range(0, height):
		for i in range(0, width):
			new_RGB = [0, 0, 0]
			for z in range(3):
				if current_symbol == count_symbols:
					return message
				if current_bit < 0:
					current_bit = 6
					current_symbol += 1
					message += chr(symbol)
					symbol = 0

				symbol += convert_pixelColor(pix, i, j, z, 3) << current_bit
				current_bit -= 2
				new_RGB[z] = convert_pixelColor(pix, i, j, z, 252)
			container.putpixel((i, j), tuple(new_RGB))


def get_data_img(new_image):
	width = new_image.size[0]
	height = new_image.size[1]
	pix = new_image.load()
	for i in range(width):
		for j in range(height):
			new_RGB = [0, 0, 0]
			for z in range(3):
				new_RGB[z] = convert_pixelColor(pix, i, j, z, 3)
				new_RGB[z] <<= 6
			new_image.putpixel((i, j), tuple(new_RGB))
	new_image.save('data_img.jpg', format='jpeg')


def clean_message(image):
	width = image.size[0]
	height = image.size[1]
	pix = image.load()
	for i in range(width):
		for j in range(height):
			new_RGB = [0, 0, 0]
			for z in range(3):
				new_RGB[z] = convert_pixelColor(pix, i, j, z, 252)
			image.putpixel((i, j), tuple(new_RGB))
	return image


def LSB(image, message):
	bin_message = [ord(c) for c in message]


	new_image = fuseMessage(bin_message, image)
	new_image.save('../media/changed_image.png')

	# new_image = new_image.transform((255, 255), Image.PERSPECTIVE, (0, 1, 2, 3, 4, 5, 4, 3, 2, 1))
	print(convert(len(message), new_image))



image = downloadImage('../media/image.png')
message = ''
for i in range(100):
	message += chr(random.randint(10, 100))
print('Input:')
print(message)
print("\nDecoded:")
LSB(image, message)
