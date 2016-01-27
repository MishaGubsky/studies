class Property(object):
    def __init__(self, fget=None, fset=None, fdel=None, doc=None):
        self.fget = fget
        self.fset = fset
        self.fdel = fdel
        if doc is None and fget.__doc__ is not None:
            doc = fget.__doc__
        self.__doc__ = doc

    def __get__(self, instance, owner):
        if instance is None:
            return self
        if self.fget is None:
            raise AttributeError("can't get attr")
        return self.fget(instance)

    def __set__(self, instance, value):
        if self.fset is None:
            raise AttributeError("can't set attr")
        self.fset(instance, value)

    def __delete__(self, instance):
        if self.fdel is None:
            raise AttributeError("can't delete attr")
        self.fdel(instance)

    def getter(self, fget):
        return type(self)(fget, self.fset, self.fdel, self.__doc__)

    def setter(self, fset):
        return type(self)(self.fget, fset, self.fdel, self.__doc__)

    def deleter(self, fdel):
        return type(self)(self.fget, self.fset, fdel, self.__doc__)


class A(object):
    def __init__(self, name):
        self.__name = name

    def fget(self):
        print 'getA'
        return self.__name

    def fset(self, value):
        print 'setA'
        self.__name = value

    def fdel(self):
        print 'delA'
        del self.__name

    name = Property(fget, fset, fdel)


class B(object):
    def __init__(self, name):
        self.__name = name

    @Property
    def name(self):
        print 'getB'
        return self.__name

    @name.setter
    def name(self, value):
        print 'setB'
        self.__name = value

    @name.deleter
    def name(self):
        print 'delB'
        del self.__name


def decorator(*args, **kwargs):
    print args, kwargs

    def wrapper(func):
        def funct(*args, **kwargs):
            print args, kwargs
            return func(*args, **kwargs)
        return funct
    return wrapper


@decorator(1, 5, a=3, b=7)
def func(r, q):
    return r + q

if __name__ == '__main__':
    a = A('John')
    print a.name
    a.name = 'Kate'
    print a.name
    del a.name

    print

    b = B('Peter')
    print b.name
    b.name = 'Mary'
    print b.name
    del b.name

    print func(1, 3)

