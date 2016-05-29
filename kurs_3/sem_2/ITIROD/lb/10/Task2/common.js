function convertToNumber(numberAsString){
    var n = +numberAsString;

    return !isNaN(n) ? n : numberAsString;
}

function isNumber(value) {
    return typeof value === 'number';
}

class ArgumentException {
    constructor(message) {
        this.name = "ArgumentException";
        this.message = message;
    }
}

class InvalidOperationException {
    constructor(message) {
        this.name = "InvalidOperationException";
        this.message = message;
    }
}


function throwIfNotANumberOrNegative(value, valueName) {
    if(!isNumber(value) || value < 0) {
        alert(valueName + ' value is incorrect!');

        throw new ArgumentException(valueName);
    }
}