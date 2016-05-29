function firstTask() {
    var v = new Vector(1, 2, 3);
    var v1 = new Vector(2, 3, 4);
    console.log(v.length());
};

function secondTask() {
    t = new Task('f');
    console.log(t);
};


function thirdTask() {
    t= new ExecuteTask('f1');
    console.log(t);
};

class Vector {
    constructor(x, y, z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    plus(second) {
        return new Vector(this.x + second.x, this.y + second.y, this.z + second.z);
    }
    scalar(second) {
        return this.x * second.x + this.y * second.y + this.z * second.z;
    }
    length() {
        return Math.sqrt(this.x * this.x + this.y * this.y + this.z + this.z);
    }
    toString() {
        return "x: " + this.x + ", y: " + this.y + ", z: " + this.z;
    }
    valueOf() {
        return "(" + this.x + ", " + this.y + ", " + this.z + ")";
    }
    indexOf(index) {
        switch (index) {
            case 'x' || 'X':
                return this.x;
            case 'y' || 'Y':
                return this.y;
            case 'z' || 'Z':
                return this.z;
            default:
                return 'nothing :(';
        }
    }
};

class Task {
    constructor(name, description, StartDate, EndDate, subTasts) {
        this.name = name || "";
        this.description = description || "";
        this.StartDate = StartDate || new Date();
        this.EndDate = EndDate || new Date();
        this.subTasts = subTasts || [];
    }
}

class ExecuteTask extends Task {
    constructor(name, description, StartDate, EndDate, subTasts, percent, done) {
        super(name, description, StartDate, EndDate, subTasts);
        this.percent = +percent || 0;
        this.done = done||+percent==100;
    }
}
