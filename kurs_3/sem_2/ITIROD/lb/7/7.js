function firstTask() {
    let x = prompt("Введите координаты x1 y1 x2 y2 x3 y3 x4 y4");

    var coord = x.split(' ');
    console.log(coord);
    while (i < coord.length) {
        coord[i] = +coord[i];
        if (coord[i] === NaN) {
            return "Введено не число!";
        };
        i += 1;
    };
    if (isRectangle(coord)) {
        alert('Это прямоугольник');

        let y = prompt("Введите координаты x1 y1");
        let x1 = +prompt("Введите координату x точки", "");
        let y1 = +prompt("Введите координату y точки", "");

        if (inRectangle(coord, x1, y1)) {
            alert('точка пренадлежит прямоугольнику');
        } else {
            alert('точка не пренадлежит прямоугольнику');
        }
    } else {
        alert('Это не прямоугольник')
    };


};

function secondTask() {
    var decorator = decorator1();
    let y = prompt("Введите что-нибудь");

    decorator(y);
};

function thirdTask() {
	var decorator = decorator2();
    let y = prompt("Введите тип");

    decorator(y, 3, 34, 23);
};

//---------------------------------------------------------------------------------

function isRectangle(coord) {
    if (coord[0] == coord[2] && coord[4] == coord[6] && coord[1] == coord[3] && coord[5] == coord[7])
        return true;
    if (coord[0] == coord[6] && coord[2] == coord[4] && coord[1] == coord[7] && coord[3] == coord[5])
        return true;
    return false;
}

function inRectangle(coord, x, y) {
    if (x > Math.min(coord[0], coord[2], coord[4], coord[6]) && x < Math.max(coord[0], coord[2], coord[4], coord[6]) && y > Math.min(coord[1], coord[3], coord[5], coord[7]) && y < Math.max(coord[1], coord[3], coord[5], coord[7]))
        return true;
}

function decorator1() {
    function F(x) {
        if (typeof(x) == "number") {
            alert('это число!');
        } else {
            alert('это не число!');
        }
    }
    return F;
}

function decorator2() {
    function F(type) {
        for (var i = 1; i < arguments.length; i++) {
            if (typeof(arguments[i]) != type) {
                alert("тип аргумента "+arguments[i]+" не "+ type);
                return
            }
        }
       	alert("все аргументы типа "+ type);
    }
    return F;
}
