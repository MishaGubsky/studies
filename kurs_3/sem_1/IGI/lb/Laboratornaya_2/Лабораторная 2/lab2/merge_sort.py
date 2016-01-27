# !/usr/bin/python
# -*- coding: utf-8 -*-
from tempfile import NamedTemporaryFile as TFile
from lab2 import CustomRange

__author__ = 'asaskevich'


def merge_sort_arr(arr=[]):
    """
    Сортировка слиянием
    :param arr: массив для сортировки
    :return: отсортированный массив
    """
    if len(arr) < 2:
        return arr
    result = []
    mid = int(len(arr) / 2)
    left = merge_sort_arr(arr[:mid])
    right = merge_sort_arr(arr[mid:])
    i = 0
    j = 0
    while i < len(left) and j < len(right):
        if left[i] > right[j]:
            result += [right[j]]
            j += 1
        else:
            result += [left[i]]
            i += 1
    result += left[i:]
    result += right[j:]
    return result


def merge_sort(file, chunk_size=100):
    """
    Сортирует слиянием файл во внешней памяти
    :param file: имя файла для сортировки
    :param chunk_size: размер чанка
    """
    chunk = []
    saved_chunks = []
    positions = []
    lines = []
    files = 0

    def write_chunk(current_chunk):
        # сортирует и записывает чанк во временный файл
        temp_file = TFile()
        saved_chunks.append(temp_file)
        positions.append(0)
        lines.append(len(current_chunk))
        chunk_to_write = merge_sort_arr(current_chunk)
        for item in chunk_to_write:
            temp_file.write('{}\n'.format(item).encode('utf-8'))

    with open(file) as bigfile:
        # разделяем входной файл на чанки, отдельные чанки сортируем и сохраняем во временные файлы
        for line in bigfile.readlines():
            chunk.append(int(line))
            if len(chunk) > chunk_size:
                files += 1
                write_chunk(chunk)
                chunk.clear()
        write_chunk(chunk)
        files += 1
        chunk.clear()

    output_file = open(file, 'w')

    while files > 0:
        # до тех пор, пока есть доступные временные файлы
        min_value, in_file = 10 ** 20, 0
        min_pos = positions[in_file]
        for index in CustomRange(len(saved_chunks)):
            if lines[index] > 0:
                # ищем файл с минимальной записью
                f = saved_chunks[index]
                f.seek(positions[index])
                new_value = int(f.readline())
                new_pos = f.tell()
                if new_value < min_value:
                    min_value = new_value
                    min_pos = new_pos
                    in_file = index
        # записываем минимальную запись
        output_file.write('{}\n'.format(min_value))
        lines[in_file] -= 1
        positions[in_file] = min_pos
        if lines[in_file] == 0:
            saved_chunks[in_file].close()
            files -= 1

    output_file.close()
