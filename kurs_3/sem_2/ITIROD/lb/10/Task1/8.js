function firstTask() {
    range(4, 3, -1);
};

function secondTask() {
    sort([3, 5, 2, 5, 6, 3, 2, 7, 1]);
};


function thirdTask() {
    var a = createMatrix(3, 4);

    var b = createMatrix(3, 4);
    alert(toString(sumMatrix(a, b, 3, 4)));
};

//--------------------------for first---------------------------

function range(x) {
    if (isNaN(x)) {
        alert('Wrong first parametr');
        return
    }
    var end = x;

    var start = 0;
    if (arguments[1] != undefined) {
        if (isNaN(arguments[1])) {
            alert('Wrong second parametr');
            return
        }

        start = x
        end = arguments[1];
    }
    var step = 1;
    if (arguments[2] != undefined) {
        if (isNaN(arguments[2])) {
            alert('Wrong third parametr');
            return
        }
        if (step == 0) {
            alert("Step can't be zero!");
            return
        }
        step = arguments[2];
    }
    if ((step < 0 && start < end) || (step > 0 && start > end)) {
        alert("Wrong data");
        return
    }
    var result = [];
    var cur = start;
    while ((cur - end) * step <= 0) {
        result.push(cur);
        cur += step;
    }
    alert(result);
    return result
}

function mergesort(items, comp) {

    if (items.length < 2) {
        return items;
    }

    var middle = Math.floor(items.length / 2),
        left = items.slice(0, middle),
        right = items.slice(middle);

    return merge(mergesort(left, comp), mergesort(right, comp), comp);
}

function merge(left, right, comp) {
    var result = [],
        il = 0,
        ir = 0;

    while (il < left.length && ir < right.length) {
        if (comp(left[il], right[ir]) < 0) {
            result.push(left[il++]);
        } else {
            result.push(right[ir++]);
        }
    }

    return result.concat(left.slice(il)).concat(right.slice(ir));
}

function sort(a, comp = function(x, y) {
    if (x > y)
        return 1;
    if (x < y)
        return -1;
    return 0;
}) {
    alert(mergesort(a, comp));
}

function createMatrix(rows, cols) {
    var mas = [];
    for (var i = 0; i < rows; i++) {
        mas[i] = [];
        for (var j = 0; j < cols; j++) {
            mas[i][j] = Math.floor(Math.random() * 100);
        }
    }
    return mas;
}

function sumMatrix(a, b, rows, cols) {
    var mas = a;
    for (var i = 0; i < rows; i++) {
        for (var j = 0; j < cols; j++) {
            mas[i][j] += b[i][j]
        }
    }
    return mas;
}
function toString(matrix) {
    var str = "";

    for (var i = 0; i < matrix.length; i++) {
        for (var j = 0; j < matrix[0].length; j++){
            str += matrix[i][j] + ", "; 
        }
        str += "\n";
    }
    return str;
};