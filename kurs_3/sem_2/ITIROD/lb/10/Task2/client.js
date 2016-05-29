$(function() {
    const MessageToEncode = "Text for encoding";


    $('#runHuffmanCodeButton').click(function() {
        let huffmanEncodedData = HuffmanCodingService.encode(MessageToEncode);
        alert(`Message: ${MessageToEncode},\nEncoded: ${huffmanEncodedData.encodedData}`);
        
        let decodedMessage = HuffmanCodingService.decode(huffmanEncodedData);
        alert(`Huffman code: ${huffmanEncodedData.encodedData},\nDecoded message: ${decodedMessage}`);
    });
});