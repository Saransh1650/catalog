function readInput(){
    const inputJson = require("./input.json");
    return inputJson
}

function processInput (jsonInput){
    const data = jsonInput;
    const points = [];

    const convertToBase10 = (value, base) => {
        return parseInt(value, base);
    };

    for (const key in data) {
        if (key !== 'keys') {
            const base = parseInt(data[key].base);
            const value = data[key].value;
            const valueBase10 = convertToBase10(value, base);
            points.push({ x: parseInt(key), y: valueBase10 });
        }
    }

    return points;
};


function interpolate(f,xi,n)
{
    let result = 0;
  
    for (let i = 0; i < n; i++)
    {

        let term = f[i].y;
        for (let j = 0; j < n; j++)
        {
            if (j != i)
                term = term*(xi - f[j].x) / (f[i].x - f[j].x);
        }
  
        result += term;
    }
  
    return result;
}


const inputData = readInput();
const points = processInput(inputData);
const valueOfC = interpolate(points, 0, points.length);

console.log(valueOfC);
