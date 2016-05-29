class HuffmanCodingService {
    static encode(message) {
        let frequencyTable = { };
        let codesTable = { };
        let inversedCodesTable = { };

        for(let i = 0; i < message.length; i++) {
            let symbol = message[i];
            if(symbol in frequencyTable) {
                frequencyTable[symbol]++;
            }
            else{
                frequencyTable[symbol] = 1;
            }
        }

        let leafs = Object.keys(frequencyTable).map(s => new Node(s, frequencyTable[s]));
        HuffmanCodingService.buildHTree(leafs);
        for(let i = 0; i < leafs.length; i++) {
            let code = "";
            let leaf = leafs[i];
            let symbol = leaf.symbol;
            while (leaf != null) {
                code += leaf.code;
                leaf = leaf.parent;
            }
            code = code.split("").reverse().join("");

            codesTable[symbol] = code;
            inversedCodesTable[code] = symbol;
        }

        let encodedData = "";
        for(let i = 0; i < message.length; i++) {
            let symbol = message[i];
            encodedData += codesTable[symbol];
        }

        return new HuffmanEncodedData(inversedCodesTable, encodedData);
    }

    static decode(huffmanEncodedData) {
        let codesTable = huffmanEncodedData.huffmanCodesTable;
        let encodedData = huffmanEncodedData.encodedData;
        let current = "";
        let decodedMessage = "";
        for(let i = 0; i < encodedData.length; i++) {
            current += encodedData[i];
            if(current in codesTable) {
                decodedMessage += codesTable[current];
                current = "";
            }
        }

        return decodedMessage;
    }


    static buildHTree(leafs) {
        let inversedNodesByFrequencyComparer = HuffmanCodingService.inverseComparer(HuffmanCodingService.nodesByFrequencyComparer);
        let nodes = [].concat(leafs);
        while (nodes.length > 1) {            
            nodes.sort(inversedNodesByFrequencyComparer);

            let lastIndex = nodes.length - 1;
            let almostLastIndex = nodes.length - 2;

            let lastNode = nodes[lastIndex];
            let almostLastNode = nodes[almostLastIndex];

            let parentNode = new Node(lastNode.symbol + almostLastNode.symbol, lastNode.frequency + almostLastNode.frequency);
            parentNode.left = lastNode;
            parentNode.right = almostLastNode;

            nodes[almostLastIndex] = parentNode;
            nodes.length--;
        }
    }


    static nodesByFrequencyComparer(x, y) {
        return x.frequency - y.frequency;
    }

    static inverseComparer(comparer) {
        function inversedComparer(x, y) {
            return comparer(y, x);
        }

        return inversedComparer;
    }
}


class HuffmanEncodedData {
    constructor(huffmanCodesTable, encodedData) {
        this.huffmanCodesTable = huffmanCodesTable;
        this.encodedData = encodedData;
    }
}

class Node {
    constructor(symbol, frequency) {
        let left = null;
        let right = null;

        this.symbol = symbol;
        this.frequency = frequency;
        this.parent = null;
        this.code = "";

        Object.defineProperty(this, 'left', {
            get: function() {
                return left;
            },
            set: function(node) {
                left = node;
                node.parent = this;
                node.code = 0;
            },
            enumerable: false,
            configurable: false
        });
        Object.defineProperty(this, 'right', {
            get: function() {
                return right;
            },
            set: function(node) {
                right = node;
                node.parent = this;
                node.code = 1;
            },
            enumerable: false,
            configurable: false
        });
    }

    toString() {
        return `(${this.symbol}, ${this.frequency}, parent: ${this.parent})`;
    }
}