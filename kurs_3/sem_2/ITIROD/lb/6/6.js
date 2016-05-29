function firstTask() {
    while (true) {
        var x = -prompt("Enter a first number");
        if (!x) {
            alert("Not a number!");
            break;
        }

        var y = -prompt("Enter a second number");
        if (!x) {
            alert("Not a number!");
            break;
        }
        if (x == y) {
            alert("Equel");
        } else if (x > y) {
            alert("first number more then second one");
        } else {
            alert("second number more then first one");
        }
    }
}

function secondTask() {
    while (true) {
        let floors = +prompt("Enter count floors");
        if (!floors || floors < 1) {
            alert("Wrong input!");
            break;
        }

        let entrences = +prompt("Enter count entrences");
        if (!entrences || entrences < 1) {
            alert("Wrong input!");
            break;
        }



        let appartments = +prompt("Enter count appartment on the floor");
        if (!appartments || appartments < 1) {
            alert("Wrong input!");
            break;
        }



        let appartmentNumber = +prompt("Enter appartment number");
        if (!appartmentNumber) {
            alert("Not a number!");
            break;
        }



        if (appartmentNumber < 1 || appartmentNumber > entrences * appartments * floors) {
            alert("Wrong appartmentNumber!");
            break;
        }

        alert("Your appartment at " + ((Math.floor(appartmentNumber / appartments) % floors) + 1) + " floor " + Math.floor(appartmentNumber / (appartments * floors)) + " entrence");
    }

}

function thirdTask() {
    while (true) {
        let i = +prompt("Enter number");
        if (!i || i < 1) {
            alert("Wrong input!");
            break;
        }
        if (i == 1) {
            alert(1);
        }
        let prev = 1;
        let current = 1;
        let index = 1;

        while (index < i) {
            result = prev + current
            prev = current;
            current = result;
            index += 1;
        }
        alert(current);
    }
}


function fourthTask() {
	var daysEnum = [ "sun", "mon", "tue", "wen", "thu", "fri", "sat" ];
    while (true) {
        var month = +prompt("Enter month (1..12)", "");
		var day = +prompt("Enter date (1..31)", "");
		var date = new Date('2015', month-1, day);

		if (month >=1 && month <=12 && day >= 1 && day <= 31)
	    	alert(daysEnum[date.getDay()]);
	    else
	    	throw "Wrong data";
    }
}