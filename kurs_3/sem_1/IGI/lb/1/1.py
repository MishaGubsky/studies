import argparse

__author__ = 'Mikhail'


def word_count(new_string):
    count = dict()
    for word in new_string.split():
        if word in count:
            count[word] += 1
        else:
            count[word] = 1

    for int_count in count:
        print(int_count + '-' + str(count[int_count]))
    return count


def word_count_ultimate(count):
    print(sorted(count, key=count.get, reverse=True)[:10])
    return 1


def quick_sort(_list, first, last):
    if first < last:
        f = first
        l = last
        m = int((first + last) / 2)

        while f <= l:
            while _list[f] < _list[m]:
                f += 1
            while _list[l] > _list[m]:
                l -= 1
            if f <= l:
                temp = _list[f]
                _list[f] = _list[l]
                _list[l] = temp
                f += 1
                l -= 1
        if first < l:
            quick_sort(_list, first, l)
        if last > f:
            quick_sort(_list, f, last)


def merge_sort(arr):
    if len(arr) == 1:
        return arr
    else:
        m = int(len(arr) / 2)
        l = merge_sort(arr[:m])
        r = merge_sort(arr[m:])

        if not len(l) or not len(r):
            return l or r

        result = []
        i = j = 0

        while len(result) < len(r) + len(l):
            if l[i] < r[j]:
                result.append(l[i])
                i += 1
            else:
                result.append(r[j])
                j += 1
            if i == len(l) or j == len(r):
                result.extend(l[i:] or r[j:])
                break
        return result


def fib(n):
    a, b = 1, 1
    while a < n:
        yield a
        a, b = b, a+b


parser = argparse.ArgumentParser()
parser.add_argument('-1', '--word_count', action='store')
parser.add_argument('-2', '--word_10', action='store')
parser.add_argument('-3', '--quick_sort', action='store')
parser.add_argument('-4', '--merge_sort', action='store')
parser.add_argument('-5', '--fibanachi', action='store')
parser.add_argument('--file', action='store')
parser.add_argument('--params', action='store')


arg = parser.parse_args()
name = arg.file
param = arg.params


if arg.word_count == 'word_count':
    if name is not None:
        with open(name, 'r') as g:
            word_count(g.read())
    else:
        word_count(param)


if arg.word_10 == 'word_10':
    if name is not None:
        with open(name, 'r') as g:
            print(word_count_ultimate(word_count(g.read())))
    else:
        print(word_count_ultimate(word_count(param)))

if arg.quick_sort == 'quick_sort':
    if name is not None:
        with open(name, 'r') as g:
            d = g.read().split()
            for i in range(len(d)):
                d[i] = int(d[i])
            quick_sort(d, 0, len(d) - 1)
            print(d)
    else:
        d = param.split()
        for i in range(len(d)):
            d[i] = int(d[i])
        quick_sort(d, 0, len(d) - 1)
        print(d)

if arg.merge_sort == 'merge_sort':
    if name is not None:
        with open(name, 'r') as g:
            d = g.read().split()
            for i in range(len(d)):
                d[i] = int(d[i])
            print(merge_sort(d))
    else:
        d = param.split()
        for i in range(len(d)):
            d[i] = int(d[i])
        print(merge_sort(d))


if arg.fibanachi is not None:
    for i in (fib(int(arg.fibanachi))):
        print(i)
