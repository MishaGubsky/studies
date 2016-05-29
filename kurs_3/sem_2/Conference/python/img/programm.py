import math

__author__ = 'Mikhail'
import random
from PIL import Image, ImageDraw

# !/usr/bin/python -tt
# -*- coding: utf-8 -*-
import codecs


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
	current_bit, coding_bits = 6, 0
	current_symbol = 0
	count_symbols = len(bin_message)
	for j in range(0, height):
		for i in range(0, width):
			new_RGB = list(pix[i, j])
			for z in range(3):
				if coding_bits == 8:
					current_symbol += 1
					coding_bits = 0
					if current_symbol == count_symbols:
						container.putpixel((i, j), tuple(new_RGB))
						return container
				if current_bit < 0:
					current_bit = 6

				secret_byte = generateSecretByte(bin_message, current_symbol, current_bit)
				current_bit -= 2
				coding_bits += 2
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
	new_image.save('data_img.jpg')


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


def rotate(filepath):
	new_image = downloadImage(filepath)
	new_image = new_image.rotate(90)
	new_image.save(filepath)

	new_image = downloadImage(filepath)
	new_image = new_image.rotate(90)
	new_image.save(filepath)

	new_image = downloadImage(filepath)
	new_image = new_image.rotate(90)
	new_image.save(filepath)

	new_image = downloadImage(filepath)
	new_image = new_image.rotate(90)
	new_image.save(filepath)


def calc_percent(str, message):
	ident = 0
	for i in range(len(message)):
		if ord(str[i]) == ord(message[i]):
			ident += 1
	return math.floor(ident * 100 / len(message))


def LSB(message):
	image = downloadImage('./png/img.png')
	filepath = './png/encrypt_image.png'

	bin_message = [ord(c) for c in message]

	new_image = fuseMessage(bin_message, image)
	new_image.save(filepath)
	# rotate(filepath)
	new_image = downloadImage(filepath)

	new_image = new_image.transform((255, 255), Image.PERSPECTIVE, (1, 0, 0, 0, 0, 0, 0, 0))


	# new_image = new_image.transform((255, 255), Image.PERSPECTIVE, (0.5, 0, 0, 0, 2, 0, 0, 0))
	# new_image = new_image.transform((255, 255), Image.PERSPECTIVE, (1, 1, 0, 1, 1, 0, 0, 0))
	# new_image = new_image.transform((255, 255), Image.PERSPECTIVE, (1, 0, 2, 0, 1, 0, 3, 0))

	# new_image = new_image.transform((255, 255), Image.AFFINE, (1, 0, 0, 0, 1, 0))

	# new_image = new_image.transform((255, 255), Image.AFFINE, (1, 1, 0, 1, 0, 0))
	# new_image = new_image.transform((255, 255), Image.AFFINE, (0.5, 2, 0, 0.5, 1, 0))
	# new_image = new_image.transform((255, 255), Image.AFFINE, (7, 2, 0, 9, 8, 0))

	# new_image = new_image.transform((255, 255), Image.EXTENT, (0, 0, 255, 255))

	# new_image = new_image.transform((255, 255), Image.EXTENT, (1, 0, 255, 255))
	# new_image = new_image.transform((255, 255), Image.EXTENT, (0, 0, 50, 0))
	# new_image = new_image.transform((255, 255), Image.EXTENT, (0, 0, 5, 0))



	new_image.save('./png/transform_img.png')
	with open('output', 'w', encoding='utf-16') as f:
		f.write('Input:\n' + message + '\n\nOutput:\n')
		new_message = convert(len(message), new_image)
		print('Messages identical to ' + str(calc_percent(new_message, message)) + '%')
		f.write(new_message)



	# clean_message(new_image).save('./png/clean_image.png')


message = 'success_1'
# for i in range(100):
# 	message += chr(random.randint(32, 126))
LSB(message)
